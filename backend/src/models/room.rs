use serde::{Deserialize, Serialize};

#[derive(Debug, Serialize, Clone)]
pub struct Room {
    pub id: String,
    pub name: String,
    pub description: Option<String>,
    pub created_by: String,
    pub created_at: String,
    pub member_count: i64,
}

#[derive(Debug, Deserialize)]
pub struct CreateRoomRequest {
    pub name: String,
    pub description: Option<String>,
    pub created_by: String,
    pub room_password: String,
}

#[derive(Debug, Deserialize)]
pub struct DeleteRoomBody {
    pub room_password: String,
}
