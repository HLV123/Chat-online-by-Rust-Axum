use axum::{
    extract::{ws::{Message, WebSocket, WebSocketUpgrade}, Path, Query, State},
    response::IntoResponse,
};
use futures_util::{SinkExt, StreamExt};
use serde::Deserialize;
use std::sync::Arc;
use tokio::sync::broadcast;

use crate::db::{get_room_members_online, touch_online};
use crate::state::AppState;

/// WS URL chi can nickname, password gui trong message dau tien
#[derive(Debug, Deserialize)]
pub struct WsQuery {
    pub nickname: String,
}

// ── GET /ws/:room_id?nickname=xxx ──
pub async fn ws_handler(
    ws: WebSocketUpgrade,
    Path(room_id): Path<String>,
    Query(query): Query<WsQuery>,
    State(state): State<Arc<AppState>>,
) -> impl IntoResponse {
    let nickname = query.nickname.trim().to_string();
    if nickname.is_empty() || nickname.len() > 50 {
        return axum::http::Response::builder()
            .status(400).body(axum::body::Body::from("Nickname khong hop le")).unwrap().into_response();
    }
    ws.on_upgrade(move |socket| handle_socket(socket, room_id, nickname, state)).into_response()
}

async fn handle_socket(mut socket: WebSocket, room_id: String, nickname: String, state: Arc<AppState>) {
    // ═══ BUOC 1: Doi message "auth" dau tien chua password ═══
    let password = match wait_for_auth(&mut socket).await {
        Some(pw) => pw,
        None => {
            let _ = socket.send(Message::Text(
                serde_json::json!({"type":"error","content":"Khong nhan duoc auth message"}).to_string().into()
            )).await;
            let _ = socket.close().await;
            return;
        }
    };

    if password.is_empty() || password.len() > 100 {
        let _ = socket.send(Message::Text(
            serde_json::json!({"type":"error","content":"Password khong hop le"}).to_string().into()
        )).await;
        let _ = socket.close().await;
        return;
    }

    // ═══ BUOC 2: Xac thuc nickname + password (bcrypt trong spawn_blocking) ═══
    let auth_result = {
        let db = state.db.lock().await;
        db.query_row("SELECT password FROM users WHERE nickname = ?1", [&nickname], |row| row.get::<_, String>(0)).ok()
    };

    match auth_result {
        None => {
            // Nickname chua co → tao moi
            let pw_clone = password.clone();
            let hashed = match tokio::task::spawn_blocking(move || bcrypt::hash(&pw_clone, bcrypt::DEFAULT_COST)).await {
                Ok(Ok(h)) => h,
                _ => {
                    let _ = socket.send(Message::Text(serde_json::json!({"type":"error","content":"Loi hash"}).to_string().into())).await;
                    let _ = socket.close().await;
                    return;
                }
            };
            let db = state.db.lock().await;
            if let Err(e) = db.execute("INSERT INTO users (nickname, password) VALUES (?1, ?2)", (&nickname, &hashed)) {
                eprintln!("[AUTH] Loi tao user {}: {}", nickname, e);
                let _ = socket.send(Message::Text(serde_json::json!({"type":"error","content":"Loi tao tai khoan"}).to_string().into())).await;
                let _ = socket.close().await;
                return;
            }
            // Gui thong bao auth thanh cong (nickname moi)
            let _ = socket.send(Message::Text(serde_json::json!({"type":"auth_ok","is_new":true}).to_string().into())).await;
        }
        Some(stored_hash) => {
            // Nickname da co → verify
            let pw_clone = password.clone();
            let hash_clone = stored_hash.clone();
            let ok = tokio::task::spawn_blocking(move || bcrypt::verify(&pw_clone, &hash_clone).unwrap_or(false))
                .await.unwrap_or(false);
            if !ok {
                let _ = socket.send(Message::Text(serde_json::json!({"type":"auth_fail","content":"Sai mat khau"}).to_string().into())).await;
                let _ = socket.close().await;
                return;
            }
            let _ = socket.send(Message::Text(serde_json::json!({"type":"auth_ok","is_new":false}).to_string().into())).await;
        }
    }

    // ═══ BUOC 3: Auth thanh cong — bat dau chat binh thuong ═══
    let (mut sender, mut receiver) = socket.split();

    let tx = {
        let mut rooms_tx = state.rooms_tx.lock().unwrap_or_else(|e| e.into_inner());
        rooms_tx.entry(room_id.clone()).or_insert_with(|| broadcast::channel(256).0).clone()
    };
    let mut rx = tx.subscribe();

    // Tang connection count
    {
        let mut conns = state.active_connections.lock().unwrap_or_else(|e| e.into_inner());
        *conns.entry(nickname.clone()).or_insert(0) += 1;
    }

    // Touch online
    { let db = state.db.lock().await; touch_online(&db, &nickname); }

    // First join check
    let is_first_join = {
        let db = state.db.lock().await;
        let _ = db.execute("INSERT OR IGNORE INTO room_first_joins (room_id, nickname) VALUES (?1, ?2)", (&room_id, &nickname));
        db.changes() > 0
    };

    if is_first_join {
        let _ = tx.send(serde_json::json!({"type":"system","id":nanoid::nanoid!(8),"content":format!("{} da tham gia phong", nickname),"event":"user_joined"}).to_string());
    }

    // Gui members online
    { let db = state.db.lock().await; let members = get_room_members_online(&db, &room_id);
      let _ = tx.send(serde_json::json!({"type":"members_update","members":members}).to_string()); }

    // Task SEND
    let send_room = room_id.clone();
    let mut send_task = tokio::spawn(async move {
        loop {
            match rx.recv().await {
                Ok(msg) => { if sender.send(Message::Text(msg.into())).await.is_err() { break; } }
                Err(broadcast::error::RecvError::Lagged(n)) => { eprintln!("[WS] Lag {} in {}", n, send_room); continue; }
                Err(broadcast::error::RecvError::Closed) => break,
            }
        }
    });

    // Task RECV
    let tx2 = tx.clone();
    let room2 = room_id.clone();
    let nick2 = nickname.clone();
    let state2 = state.clone();

    let mut recv_task = tokio::spawn(async move {
        while let Some(Ok(msg)) = receiver.next().await {
            if let Message::Text(text) = msg {
                let text_str = text.to_string();
                if let Ok(parsed) = serde_json::from_str::<serde_json::Value>(&text_str) {
                    let t = parsed.get("type").and_then(|t| t.as_str()).unwrap_or("");
                    match t {
                        "chat_message" => {
                            let content = parsed.get("content").and_then(|c| c.as_str()).unwrap_or("").trim();
                            let reply_to = parsed.get("reply_to").and_then(|r| r.as_i64());
                            if !content.is_empty() && content.len() <= 2000 {
                                let result = {
                                    let db = state2.db.lock().await;
                                    match db.execute("INSERT INTO messages (room_id, nickname, content, reply_to) VALUES (?1, ?2, ?3, ?4)", (&room2, &nick2, content, reply_to)) {
                                        Ok(_) => {
                                            let rid = db.last_insert_rowid();
                                            let ts: String = db.query_row("SELECT created_at FROM messages WHERE id = ?1", [rid], |r| r.get(0)).unwrap_or_else(|_| chrono::Utc::now().to_rfc3339());
                                            Some((rid, ts))
                                        }
                                        Err(e) => { eprintln!("[DB] insert msg: {}", e); None }
                                    }
                                };
                                if let Some((mid, ts)) = result {
                                    let _ = tx2.send(serde_json::json!({"type":"chat_message","id":mid,"nickname":nick2,"content":content,"reply_to":reply_to,"created_at":ts}).to_string());
                                }
                            }
                        }
                        "typing" => {
                            let is_typing = parsed.get("is_typing").and_then(|t| t.as_bool()).unwrap_or(false);
                            let _ = tx2.send(serde_json::json!({"type":"typing","nickname":nick2,"is_typing":is_typing}).to_string());
                        }
                        "heartbeat" => { let db = state2.db.lock().await; touch_online(&db, &nick2); }
                        _ => {}
                    }
                }
            }
        }
    });

    tokio::select! { _ = &mut send_task => recv_task.abort(), _ = &mut recv_task => send_task.abort() };

    // Cleanup
    {
        let should_remove;
        { let mut conns = state.active_connections.lock().unwrap_or_else(|e| e.into_inner());
          let c = conns.entry(nickname.clone()).or_insert(0);
          if *c > 1 { *c -= 1; should_remove = false; } else { conns.remove(&nickname); should_remove = true; } }
        if should_remove { let db = state.db.lock().await; let _ = db.execute("DELETE FROM online_users WHERE nickname = ?1", [&nickname]); }
    }

    { let db = state.db.lock().await; let members = get_room_members_online(&db, &room_id);
      let _ = tx.send(serde_json::json!({"type":"members_update","members":members}).to_string()); }

    { let mut rooms_tx = state.rooms_tx.lock().unwrap_or_else(|e| e.into_inner());
      if let Some(s) = rooms_tx.get(&room_id) { if s.receiver_count() == 0 { rooms_tx.remove(&room_id); } } }
}

/// Doi message dau tien la { "type": "auth", "password": "xxx" }
async fn wait_for_auth(socket: &mut WebSocket) -> Option<String> {
    // Timeout 10 giay cho auth message
    let timeout = tokio::time::timeout(std::time::Duration::from_secs(10), socket.recv()).await;
    match timeout {
        Ok(Some(Ok(Message::Text(text)))) => {
            let text_str = text.to_string();
            if let Ok(parsed) = serde_json::from_str::<serde_json::Value>(&text_str) {
                if parsed.get("type").and_then(|t| t.as_str()) == Some("auth") {
                    return parsed.get("password").and_then(|p| p.as_str()).map(|s| s.trim().to_string());
                }
            }
            None
        }
        _ => None,
    }
}
