use axum::{
    extract::{Path, Query, State},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use std::sync::Arc;

use crate::models::{ChatMessage, CreateRoomRequest, DeleteRoomBody, MessagesQuery, Room, UnreadQuery};
use crate::state::AppState;

// ── GET /api/rooms ──
pub async fn get_rooms(State(state): State<Arc<AppState>>) -> impl IntoResponse {
    let db = state.db.lock().await;
    // #5b: member_count dem tu room_first_joins + online_users (nguoi dang online)
    let stmt = db.prepare(
        "SELECT r.id, r.name, r.description, r.created_by, r.created_at,
                (SELECT COUNT(*) FROM room_first_joins f
                 INNER JOIN online_users o ON f.nickname = o.nickname
                 WHERE f.room_id = r.id
                   AND o.last_active >= DATETIME('now', '-60 seconds')) as member_count
         FROM rooms r
         WHERE r.is_active = TRUE
         ORDER BY r.created_at DESC",
    );

    let mut stmt = match stmt {
        Ok(s) => s,
        Err(e) => {
            eprintln!("[DB ERROR] get_rooms: {}", e);
            return (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": "DB error" }))).into_response();
        }
    };

    let result = match stmt.query_map([], |row| {
        Ok(Room {
            id: row.get(0)?,
            name: row.get(1)?,
            description: row.get(2)?,
            created_by: row.get(3)?,
            created_at: row.get(4)?,
            member_count: row.get(5)?,
        })
    }) {
        Ok(rows) => {
            let rooms: Vec<Room> = rows.filter_map(|r| r.ok()).collect();
            Json(rooms).into_response()
        }
        Err(e) => {
            eprintln!("[DB ERROR] get_rooms query: {}", e);
            (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": "DB error" }))).into_response()
        }
    };
    result
}

// ── POST /api/rooms — #1: hash room_password voi bcrypt ──
pub async fn create_room(
    State(state): State<Arc<AppState>>,
    Json(body): Json<CreateRoomRequest>,
) -> impl IntoResponse {
    let name = body.name.trim().to_string();
    let password = body.room_password.trim().to_string();

    if name.is_empty() {
        return (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": "Ten phong khong duoc de trong" }))).into_response();
    }
    if name.len() > 100 {
        return (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": "Ten phong khong qua 100 ky tu" }))).into_response();
    }
    if password.is_empty() {
        return (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": "Mat khau phong khong duoc de trong" }))).into_response();
    }
    if password.len() > 100 {
        return (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": "Mat khau khong qua 100 ky tu" }))).into_response();
    }

    // Hash password truoc khi luu (spawn_blocking vi bcrypt la CPU-bound)
    let pw_clone = password.clone();
    let hashed = match tokio::task::spawn_blocking(move || bcrypt::hash(&pw_clone, bcrypt::DEFAULT_COST)).await {
        Ok(Ok(h)) => h,
        _ => return (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": "Loi hash mat khau" }))).into_response(),
    };

    let room_id = nanoid::nanoid!(10);
    let db = state.db.lock().await;

    match db.execute(
        "INSERT INTO rooms (id, name, description, created_by, room_password) VALUES (?1, ?2, ?3, ?4, ?5)",
        (&room_id, &name, &body.description, &body.created_by, &hashed),
    ) {
        Ok(_) => {
            println!("[ROOM] Tao phong: {} ({})", name, room_id);
            (StatusCode::CREATED, Json(serde_json::json!({ "id": room_id, "name": name }))).into_response()
        }
        Err(e) => {
            let msg = format!("{}", e);
            let text = if msg.contains("UNIQUE") { "Ten phong da ton tai" } else { &msg };
            (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": text }))).into_response()
        }
    }
}

// ── GET /api/rooms/:id ──
pub async fn get_room(
    State(state): State<Arc<AppState>>,
    Path(id): Path<String>,
) -> impl IntoResponse {
    let db = state.db.lock().await;
    match db.query_row(
        "SELECT id, name, description, created_by, created_at FROM rooms WHERE id = ?1 AND is_active = TRUE",
        [&id],
        |row| Ok(serde_json::json!({
            "id": row.get::<_, String>(0)?,
            "name": row.get::<_, String>(1)?,
            "description": row.get::<_, Option<String>>(2)?,
            "created_by": row.get::<_, String>(3)?,
            "created_at": row.get::<_, String>(4)?,
        })),
    ) {
        Ok(r) => Json(r).into_response(),
        Err(_) => (StatusCode::NOT_FOUND, Json(serde_json::json!({ "error": "Phong khong ton tai" }))).into_response(),
    }
}

// ── POST /api/rooms/:id/delete — bcrypt verify via spawn_blocking ──
pub async fn delete_room(
    State(state): State<Arc<AppState>>,
    Path(id): Path<String>,
    Json(body): Json<DeleteRoomBody>,
) -> impl IntoResponse {
    let password = body.room_password.trim().to_string();
    if password.is_empty() {
        return (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": "Can nhap mat khau phong" }))).into_response();
    }

    // Query hash, roi drop db lock truoc khi chay bcrypt
    let stored_hash = {
        let db = state.db.lock().await;
        db.query_row(
            "SELECT room_password FROM rooms WHERE id = ?1 AND is_active = TRUE",
            [&id], |row| row.get::<_, Option<String>>(0),
        ).ok().flatten()
    };

    match stored_hash {
        None => (StatusCode::NOT_FOUND, Json(serde_json::json!({ "error": "Phong khong ton tai" }))).into_response(),
        Some(hash) => {
            // spawn_blocking cho bcrypt verify
            let pw = password.clone();
            let h = hash.clone();
            let ok = tokio::task::spawn_blocking(move || bcrypt::verify(&pw, &h).unwrap_or(false))
                .await.unwrap_or(false);
            if !ok {
                return (StatusCode::FORBIDDEN, Json(serde_json::json!({ "error": "Mat khau khong dung" }))).into_response();
            }
            let db = state.db.lock().await;
            let _ = db.execute("UPDATE rooms SET is_active = FALSE WHERE id = ?1", [&id]);
            println!("[ROOM] Xoa phong: {}", id);
            Json(serde_json::json!({ "success": true })).into_response()
        }
    }
}

// ── GET /api/rooms/:id/messages ──
pub async fn get_messages(
    State(state): State<Arc<AppState>>,
    Path(id): Path<String>,
    Query(query): Query<MessagesQuery>,
) -> impl IntoResponse {
    let limit = query.limit.unwrap_or(50).min(200);
    let db = state.db.lock().await;

    let mut stmt = match db.prepare(
        "SELECT id, room_id, nickname, content, reply_to, created_at
         FROM messages WHERE room_id = ?1
         ORDER BY created_at DESC LIMIT ?2",
    ) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("[DB ERROR] get_messages: {}", e);
            return (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": "DB error" }))).into_response();
        }
    };

    let result = match stmt.query_map(rusqlite::params![&id, limit], |row| {
        Ok(ChatMessage {
            id: row.get(0)?, room_id: row.get(1)?, nickname: row.get(2)?,
            content: row.get(3)?, reply_to: row.get(4)?, created_at: row.get(5)?,
        })
    }) {
        Ok(rows) => {
            let mut messages: Vec<ChatMessage> = rows.filter_map(|r| r.ok()).collect();
            messages.reverse();
            Json(messages).into_response()
        }
        Err(e) => {
            eprintln!("[DB ERROR] get_messages query: {}", e);
            (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": "DB error" }))).into_response()
        }
    };
    result
}

// ── GET /api/rooms/:id/unread-count?after=123 — #9: dem so tin that su ──
pub async fn get_unread_count(
    State(state): State<Arc<AppState>>,
    Path(id): Path<String>,
    Query(query): Query<UnreadQuery>,
) -> impl IntoResponse {
    let after_id = query.after.unwrap_or(0);
    let db = state.db.lock().await;

    match db.query_row(
        "SELECT COUNT(*) FROM messages WHERE room_id = ?1 AND id > ?2",
        rusqlite::params![&id, after_id],
        |row| row.get::<_, i64>(0),
    ) {
        Ok(count) => {
            // Lay tin moi nhat de hien preview
            let latest = db.query_row(
                "SELECT id, nickname, content, created_at FROM messages WHERE room_id = ?1 ORDER BY id DESC LIMIT 1",
                [&id],
                |row| Ok(serde_json::json!({
                    "id": row.get::<_, i64>(0)?,
                    "nickname": row.get::<_, String>(1)?,
                    "content": row.get::<_, String>(2)?,
                    "created_at": row.get::<_, String>(3)?,
                })),
            ).ok();

            Json(serde_json::json!({
                "count": count,
                "latest": latest,
            })).into_response()
        }
        Err(_) => Json(serde_json::json!({ "count": 0, "latest": null })).into_response(),
    }
}
