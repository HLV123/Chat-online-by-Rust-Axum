mod db;
mod handlers;
mod models;
mod state;

use axum::{
    http::{HeaderValue, Method},
    routing::{get, post},
    Json, Router,
};
use rusqlite::Connection;
use std::collections::HashMap;
use std::sync::{Arc, Mutex as StdMutex};
use tokio::sync::Mutex as TokioMutex;
use tower_http::cors::{Any, CorsLayer};
use tower_http::services::{ServeDir, ServeFile};

use crate::handlers::{rooms, websocket};
use crate::state::AppState;

#[tokio::main]
async fn main() {
    let _ = dotenvy::dotenv();

    let db_path = std::env::var("DB_PATH").unwrap_or_else(|_| "chat.db".to_string());
    let port = std::env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    let host = std::env::var("HOST").unwrap_or_else(|_| "0.0.0.0".to_string());
    let allowed_origin = std::env::var("ALLOWED_ORIGIN")
        .unwrap_or_else(|_| "*".to_string());

    let conn = Connection::open(&db_path).expect("Khong the mo database");
    db::init_db(&conn);

    let state = Arc::new(AppState {
        db: TokioMutex::new(conn),
        rooms_tx: StdMutex::new(HashMap::new()),
        active_connections: StdMutex::new(HashMap::new()),
    });

    let cors = if allowed_origin == "*" {
        CorsLayer::new()
            .allow_origin(Any)
            .allow_methods([Method::GET, Method::POST, Method::DELETE])
            .allow_headers(Any)
    } else {
        CorsLayer::new()
            .allow_origin(
                allowed_origin
                    .parse::<HeaderValue>()
                    .expect("ALLOWED_ORIGIN khong hop le"),
            )
            .allow_methods([Method::GET, Method::POST, Method::DELETE])
            .allow_headers(Any)
    };

    let api = Router::new()
        .route("/api/rooms", get(rooms::get_rooms).post(rooms::create_room))
        .route("/api/rooms/{id}", get(rooms::get_room))
        .route("/api/rooms/{id}/delete", post(rooms::delete_room))
        .route("/api/rooms/{id}/messages", get(rooms::get_messages))
        .route("/api/rooms/{id}/unread-count", get(rooms::get_unread_count))
        .route("/ws/{room_id}", get(websocket::ws_handler))
        .route("/health", get(health_check))
        .with_state(state);

    let spa = ServeDir::new("public").not_found_service(ServeFile::new("public/index.html"));

    let app = api
        .fallback_service(spa)
        .layer(cors);

    let bind_addr = format!("{}:{}", host, port);
    let listener = tokio::net::TcpListener::bind(&bind_addr)
        .await
        .expect(&format!("Khong the bind {}", bind_addr));

    println!("╔══════════════════════════════════════╗");
    println!("║     QwikChat Backend v4              ║");
    println!("║     http://{}:{:<9}        ║", host, port);
    println!("║     CORS: {:<26}║", &allowed_origin[..allowed_origin.len().min(26)]);
    println!("╚══════════════════════════════════════╝");

    axum::serve(listener, app).await.unwrap();
}

async fn health_check() -> Json<serde_json::Value> {
    Json(serde_json::json!({
        "status": "ok",
        "app": "QwikChat Backend",
        "version": "4.0.0"
    }))
}
