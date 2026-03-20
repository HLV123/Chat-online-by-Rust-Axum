use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Clone)]
pub struct ChatMessage {
    pub id: i64,
    pub room_id: String,
    pub nickname: String,
    pub content: String,
    pub reply_to: Option<i64>,
    pub created_at: String,
}

#[derive(Debug, Deserialize)]
pub struct MessagesQuery {
    pub limit: Option<i64>,
}

#[derive(Debug, Deserialize)]
pub struct UnreadQuery {
    pub after: Option<i64>,
}
