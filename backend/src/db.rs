use rusqlite::Connection;

pub fn init_db(db: &Connection) {
    db.execute_batch(
        "
        PRAGMA journal_mode=WAL;
        PRAGMA foreign_keys=ON;

        CREATE TABLE IF NOT EXISTS rooms (
            id            TEXT PRIMARY KEY,
            name          TEXT NOT NULL UNIQUE,
            description   TEXT,
            created_by    TEXT NOT NULL,
            room_password TEXT,
            created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
            is_active     BOOLEAN DEFAULT TRUE
        );

        CREATE TABLE IF NOT EXISTS messages (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id     TEXT NOT NULL,
            nickname    TEXT NOT NULL,
            content     TEXT NOT NULL,
            reply_to    INTEGER,
            created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (room_id)  REFERENCES rooms(id)    ON DELETE CASCADE,
            FOREIGN KEY (reply_to) REFERENCES messages(id)
        );

        -- users = nickname + password (bcrypt hash)
        -- Tu dong tao khi lan dau dung nickname, xac thuc lan sau
        CREATE TABLE IF NOT EXISTS users (
            nickname    TEXT PRIMARY KEY,
            password    TEXT NOT NULL,
            created_at  DATETIME DEFAULT CURRENT_TIMESTAMP
        );

        -- Thanh vien da tung vao phong (vinh vien, dung cho thong bao lan dau)
        CREATE TABLE IF NOT EXISTS room_first_joins (
            room_id     TEXT NOT NULL,
            nickname    TEXT NOT NULL,
            joined_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (room_id, nickname),
            FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
        );

        -- Ai dang mo trang web (global, cap nhat qua heartbeat)
        CREATE TABLE IF NOT EXISTS online_users (
            nickname     TEXT PRIMARY KEY,
            last_active  DATETIME DEFAULT CURRENT_TIMESTAMP
        );

        -- Tuong thich nguoc (co the bo sau)
        CREATE TABLE IF NOT EXISTS room_members (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id     TEXT NOT NULL,
            nickname    TEXT NOT NULL,
            joined_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
            UNIQUE(room_id, nickname)
        );

        CREATE INDEX IF NOT EXISTS idx_messages_room  ON messages(room_id, created_at DESC);
        CREATE INDEX IF NOT EXISTS idx_members_room   ON room_members(room_id);
    ",
    )
    .expect("Khong the tao bang");

    let col_exists: bool = db
        .query_row(
            "SELECT COUNT(*) FROM pragma_table_info('rooms') WHERE name='room_password'",
            [],
            |r| r.get::<_, i64>(0),
        )
        .unwrap_or(0)
        > 0;
    if !col_exists {
        let _ = db.execute_batch("ALTER TABLE rooms ADD COLUMN room_password TEXT;");
    }

    let _ = db.execute("DELETE FROM room_members", []);
    let _ = db.execute("DELETE FROM online_users", []);

    println!("[DB] Database san sang.");
}

pub fn touch_online(db: &Connection, nickname: &str) {
    let _ = db.execute(
        "INSERT INTO online_users (nickname, last_active) VALUES (?1, CURRENT_TIMESTAMP)
         ON CONFLICT(nickname) DO UPDATE SET last_active = CURRENT_TIMESTAMP",
        [nickname],
    );
}

pub fn get_room_members_online(db: &Connection, room_id: &str) -> Vec<String> {
    let mut stmt = match db.prepare(
        "SELECT f.nickname FROM room_first_joins f
         INNER JOIN online_users o ON f.nickname = o.nickname
         WHERE f.room_id = ?1
           AND o.last_active >= DATETIME('now', '-60 seconds')
         ORDER BY f.joined_at",
    ) {
        Ok(s) => s,
        Err(e) => {
            eprintln!("[DB ERROR] get_room_members_online: {}", e);
            return Vec::new();
        }
    };
    let result: Vec<String> = match stmt.query_map([room_id], |row| row.get(0)) {
        Ok(rows) => rows.filter_map(|r| r.ok()).collect(),
        Err(e) => {
            eprintln!("[DB ERROR] get_room_members_online query: {}", e);
            Vec::new()
        }
    };
    result
}
