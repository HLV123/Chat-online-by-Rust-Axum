use rusqlite::Connection;
use std::collections::HashMap;
use std::sync::Mutex as StdMutex;
use tokio::sync::broadcast;
use tokio::sync::Mutex as TokioMutex;

pub struct AppState {
    pub db: TokioMutex<Connection>,
    pub rooms_tx: StdMutex<HashMap<String, broadcast::Sender<String>>>,
    pub active_connections: StdMutex<HashMap<String, usize>>,
}
