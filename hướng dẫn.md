# HƯỚNG DẪN CHI TIẾT — QwikChat v4 (Windows)

## Từ cài đặt môi trường → Code → Database → Test → Deploy ngrok

**Stack:** Qwik/JavaScript + Rust/Axum + SQLite + bcrypt + ngrok
**Runtime:** Bun
**OS:** Windows 10/11

---

## MỤC LỤC

1. [Cài đặt môi trường](#1-cài-đặt-môi-trường)
2. [Cấu trúc dự án](#2-cấu-trúc-dự-án)
3. [Setup Backend](#3-setup-backend)
4. [Setup Database](#4-setup-database)
5. [Insert dữ liệu mẫu](#5-insert-dữ-liệu-mẫu)
6. [Setup Frontend](#6-setup-frontend)
7. [Chạy và test (chế độ dev)](#7-chạy-và-test-chế-độ-dev)
8. [Deploy bằng ngrok](#8-deploy-bằng-ngrok)
9. [Xử lý lỗi thường gặp](#9-xử-lý-lỗi-thường-gặp)

---

## 1. CÀI ĐẶT MÔI TRƯỜNG

### 1.1. Cài Visual Studio Build Tools (bắt buộc cho Rust trên Windows)

- Tải từ: https://visualstudio.microsoft.com/visual-cpp-build-tools/
- Chạy installer → tích chọn **"Desktop development with C++"** → Install
- Đợi cài xong (khoảng 2–5 GB, mất 5–15 phút)

---

### 1.2. Cài Rust

- Tải từ: https://www.rust-lang.org/tools/install
- Chạy `rustup-init.exe` → nhấn **1** (default) → Enter → đợi xong

Đóng terminal, mở PowerShell mới, kiểm tra:

```powershell
rustc --version      # ✅ rustc 1.xx.x
cargo --version      # ✅ cargo 1.xx.x
```

---

### 1.3. Cài Bun

Mở PowerShell (Run as Administrator):

```powershell
powershell -c "irm bun.sh/install.ps1 | iex"
```

Đóng terminal, mở lại, kiểm tra:

```powershell
bun --version        # ✅ 1.x.x
```

---

### 1.4. Cài ngrok

**Bước 1:** Tải từ https://ngrok.com/download → chọn Windows → giải nén → copy `ngrok.exe` vào `C:\ngrok\`

**Bước 2:** Thêm `C:\ngrok` vào PATH:
- Win + S → "Environment Variables" → Edit the system environment variables
- Environment Variables → Path → Edit → New → nhập `C:\ngrok` → OK

**Bước 3:** Đăng ký tại https://dashboard.ngrok.com/signup → lấy auth token

**Bước 4:** Mở PowerShell mới:

```powershell
ngrok config add-authtoken YOUR_AUTH_TOKEN
ngrok version        # ✅ ngrok version 3.x.x
```

---

### 1.5. Cài SQLite CLI

- Tải từ: https://www.sqlite.org/download.html → **Precompiled Binaries for Windows**
- Giải nén → copy vào `C:\sqlite\` → thêm vào PATH (tương tự bước ngrok)

```powershell
sqlite3 --version    # ✅ 3.x.x
```

---

### 1.6. Checklist môi trường

```powershell
rustc --version      # ✅ rustc 1.xx.x
cargo --version      # ✅ cargo 1.xx.x
bun --version        # ✅ 1.x.x
ngrok version        # ✅ ngrok version 3.x.x
sqlite3 --version    # ✅ 3.x.x
```

---

## 2. CẤU TRÚC DỰ ÁN

```
qwikchat/
├── backend/
│   ├── Cargo.toml
│   ├── .env                              # Biến môi trường backend
│   ├── .env.example
│   ├── seed.sql
│   ├── chat.db                           # SQLite (tự tạo khi cargo run)
│   ├── public/                           # Frontend build output (tự tạo khi deploy)
│   └── src/
│       ├── main.rs                       # Entry point, router, ServeDir, CORS
│       ├── state.rs
│       ├── db.rs
│       ├── models/
│       │   ├── mod.rs
│       │   ├── room.rs
│       │   └── message.rs
│       └── handlers/
│           ├── mod.rs
│           ├── rooms.rs                  # REST API
│           └── websocket.rs             # WebSocket
│
├── frontend/
│   ├── package.json
│   ├── vite.config.ts
│   ├── prerender.mjs                     # Script sinh dist/index.html (SSR)
│   ├── build-deploy.ps1                  # Script build + copy vào backend
│   ├── .env                              # VITE_API_URL (dùng khi dev)
│   ├── .env.production                   # VITE_API_URL= (rỗng, dùng khi build)
│   ├── .env.example
│   └── src/
│       ├── root.jsx
│       ├── global.css
│       ├── entry.dev.tsx
│       ├── entry.ssr.tsx
│       ├── entry.preview.tsx
│       ├── utils/
│       │   └── websocket.js
│       ├── components/
│       │   ├── Sidebar.jsx
│       │   ├── ChatBox.jsx
│       │   └── Modals.jsx
│       └── routes/
│           ├── layout.jsx
│           └── index.jsx
```

### Tính năng chính

| Tính năng | Mô tả |
|-----------|-------|
| Chat real-time | WebSocket per-room với tokio broadcast |
| Xác thực nickname | Nickname + password (bcrypt), tự tạo lần đầu |
| Xóa phòng bằng mật khẩu | Mật khẩu phòng (bcrypt), nhập đúng mới xóa |
| Unread badge | Polling `/unread-count` mỗi 3 giây |
| Online tracking | Heartbeat 30s, bảng `online_users` |
| Reply tin nhắn | Reply-to với preview |
| Typing indicator | Debounce 2 giây |
| Draft per-room | Lưu localStorage |
| Auto reconnect | Exponential backoff, tối đa 5 lần |
| Soft delete | Phòng xóa chỉ đánh dấu `is_active=FALSE` |

---

## 3. SETUP BACKEND

### 3.1. Tạo file .env

```powershell
cd backend
copy .env.example .env
```

Nội dung `backend/.env`:

```
DB_PATH=chat.db
PORT=3000
HOST=0.0.0.0
ALLOWED_ORIGIN=http://localhost:5173
```

> `HOST=0.0.0.0` để backend lắng nghe cả kết nối ngoài (cần thiết khi dùng ngrok).
> `ALLOWED_ORIGIN` chỉ dùng khi dev (frontend chạy riêng trên port 5173).

### 3.2. Build lần đầu

```powershell
cargo build
```

> **Lần đầu mất 3–7 phút** (tải + compile ~134 packages).

### 3.3. Chạy thử

```powershell
cargo run
```

Kết quả:

```
[DB] Database san sang.
╔════════════════════════════╗
║     QwikChat Backend v4    ║
║     http://0.0.0.0:3000    ║
╚════════════════════════════╝
```

Test: http://localhost:3000/health → `{"status":"ok","app":"QwikChat Backend","version":"4.0.0"}`

---

## 4. SETUP DATABASE

Database tự động tạo khi chạy `cargo run` lần đầu. Kiểm tra:

```powershell
sqlite3 chat.db ".tables"
# messages          room_first_joins  rooms
# online_users      room_members      users
```

---

## 5. INSERT DỮ LIỆU MẪU

> **Lưu ý:** Seed data không có cột `room_password`. Các phòng seed sẽ không có mật khẩu (không thể xóa bằng UI). Nên tạo phòng mới qua giao diện thay vì seed.

Nếu vẫn muốn seed:

```powershell
cd backend
Get-Content seed.sql | sqlite3 chat.db
```

---

## 6. SETUP FRONTEND

### 6.1. Cài dependencies

```powershell
cd frontend
bun install
```

### 6.2. Kiểm tra file .env (dùng khi dev)

`frontend/.env`:

```
VITE_API_URL=http://localhost:3000
VITE_WS_URL=ws://localhost:3000
```

`frontend/.env.production` (dùng khi build, không cần sửa):

```
VITE_API_URL=
```

> Để trống = dùng relative URL (`/api/rooms` thay vì `http://...`). Frontend và backend cùng origin nên không cần URL tuyệt đối.

---

## 7. CHẠY VÀ TEST (CHẾ ĐỘ DEV)

Mở **2 terminal**:

**Terminal 1 — Backend:**

```powershell
cd backend
cargo run
```

**Terminal 2 — Frontend:**

```powershell
cd frontend
bun run dev
```

Mở trình duyệt: http://localhost:5173

### Test từng bước

**Test 1: Tạo nickname**

1. Nhập nickname ở sidebar: `TestUser`
2. Bấm vào bất kỳ phòng nào → hiện modal **"Xác thực nickname"**
3. Nhập mật khẩu (tối thiểu 4 ký tự): `1234` → Xác nhận
4. Vào phòng thành công, icon 🔒 hiện bên cạnh nickname

> Lần đầu dùng nickname → tự tạo tài khoản. Lần sau → phải nhập đúng mật khẩu đã đặt.

**Test 2: Chat real-time**

1. Mở tab 2, vào http://localhost:5173
2. Nhập nickname khác: `TestUser2`, mật khẩu: `5678`
3. Cùng vào 1 phòng → chat qua lại real-time

**Test 3: Tạo phòng mới**

1. Bấm nút **+** → nhập tên phòng, mô tả, mật khẩu phòng
2. Bấm Tạo → phòng xuất hiện, tự động vào

**Test 4: Xóa phòng**

1. Hover vào phòng trong sidebar → hiện nút 🗑️
2. Bấm → nhập đúng mật khẩu phòng → phòng bị xóa (soft delete)

**Test 5: Unread badge**

1. Tab 1 đang ở phòng A
2. Tab 2 vào phòng B, gửi tin nhắn
3. Sau ~3 giây, tab 1 thấy phòng B nhảy lên đầu + badge xanh
4. Click vào phòng B → badge biến mất

**Test 6: Sai mật khẩu nickname**

1. Tab 2 nhập nickname `TestUser` với mật khẩu sai → hiện lỗi "Sai mat khau cho nickname nay"
2. Nhập đúng `1234` → vào được

---

## 8. DEPLOY BẰNG NGROK

### 8.1. Kiến trúc

Frontend được **build và pre-render thành file tĩnh**, backend chỉ cần **1 tunnel duy nhất**:

```
Người dùng
    │
    ▼
https://abc123.ngrok-free.app        ← 1 URL duy nhất
    │
    ▼
Backend :3000  (Rust/Axum)
    ├── GET /              → public/index.html   (Qwik SSR shell)
    ├── GET /build/*.js    → public/build/       (JS chunks lazy-load)
    ├── GET /assets/*.css  → public/assets/      (CSS)
    ├── GET /favicon.svg   → public/favicon.svg
    ├── GET /api/*         → REST handlers
    └── GET /ws/*          → WebSocket handlers
```

Vì frontend và backend cùng origin → **không cần sửa CORS, không cần sửa .env**.

### 8.2. File cần có trong frontend/

Đảm bảo thư mục `frontend/` có 2 file sau (đã được cung cấp kèm dự án):

| File | Vai trò |
|------|---------|
| `build-deploy.ps1` | Script build + copy vào backend |
| `prerender.mjs` | Script sinh `dist/index.html` qua SSR |

### 8.3. Tại sao cần 3 lệnh build?

Qwik là framework SSR-first. `build.client` chỉ tạo JS chunks lazy-loaded, **không sinh `index.html`**. Qwikloader cần HTML đã có `q:container`, `q:base`, serialized state thì mới khởi động được — nếu không có SSR shell, trang sẽ trắng.

| Bước | Lệnh | Output |
|------|------|--------|
| 1 | `bun run build.client` | `frontend/dist/` — JS chunks, CSS, favicon, q-manifest.json |
| 2 | `bun run build.preview` | `frontend/server/entry.preview.js` — SSR renderer |
| 3 | `bun prerender.mjs` | `frontend/dist/index.html` — HTML thật sự có `q:container` |

Sau đó copy toàn bộ `frontend/dist/` → `backend/public/`. Thư mục `frontend/server/` **không copy**.

### 8.4. Các bước deploy

**Bước 1 — Cài dependencies (chỉ cần làm 1 lần):**

```powershell
cd frontend
bun install
cd ..
```

**Bước 2 — Build và copy vào backend:**

Mở PowerShell tại thư mục **gốc** (chứa cả `backend/` và `frontend/`):

```powershell
.\frontend\build-deploy.ps1
```

Script tự động chạy đủ 3 lệnh build rồi copy:

```
[1/3] Build client (bun run build.client)...
OK: frontend/dist/ co JS chunks.

[2/3] Build SSR entry (bun run build.preview)...
OK: frontend/server/entry.preview.js san sang.

[3/3] Prerender index.html (bun prerender.mjs)...
OK: frontend/dist/index.html da duoc tao.

Copy frontend/dist/ -> backend/public/ ... OK
```

> Mất khoảng 1–3 phút. Chỉ cần chạy lại khi sửa code frontend.

**Bước 3 — Chạy backend:**

```powershell
cd backend
cargo run
```

Kiểm tra local: mở http://localhost:3000 → thấy giao diện QwikChat là OK.

**Bước 4 — Mở ngrok:**

Mở terminal mới (để backend vẫn chạy ở terminal kia):

```powershell
ngrok http 3000
```

Kết quả:

```
Forwarding   https://abc123.ngrok-free.app -> http://localhost:3000
```

**Bước 5 — Chia sẻ:**

Gửi URL ngrok cho bạn bè ở máy khác chat:

```
https://abc123.ngrok-free.app
```

Họ mở trên trình duyệt bất kỳ → dùng được luôn, không cần cài gì.

> **Lưu ý ngrok free:** Lần đầu truy cập có thể sẽ thấy trang "Visit Site" của ngrok, bấm nút để tiếp tục.

### 8.5. Checklist deploy

```
1. ✅ cd frontend → bun install → cd ..       (chỉ lần đầu)
2. ✅ .\frontend\build-deploy.ps1              (build + copy → backend/public/)
3. ✅ cd backend → cargo run
4. ✅ Mở http://localhost:3000 → thấy UI
5. ✅ Terminal mới → ngrok http 3000 → copy URL
6. ✅ Gửi URL cho giảng viên
7. ✅ Demo: 2 trình duyệt, 2 nickname khác nhau, chat qua lại
```

### 8.6. Khi cần rebuild frontend

Mỗi lần sửa code frontend:

```powershell
# Ctrl+C để dừng backend
.\frontend\build-deploy.ps1
cd backend
cargo run
# Không cần restart ngrok — URL giữ nguyên trong phiên
```

---

## 9. XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi: Trang trắng khi mở http://localhost:3000

**Nguyên nhân:** `backend/public/` chưa có hoặc thiếu `index.html`.

**Sửa:**
```powershell
# Chạy lại từ thư mục gốc
.\frontend\build-deploy.ps1
```

Kiểm tra `backend/public/index.html` có tồn tại không.

---

### Lỗi: `build-deploy.ps1` thất bại ở bước prerender

**Triệu chứng:** `LOI: Khong load duoc server/entry.preview.js`

**Nguyên nhân:** `build.preview` chưa chạy hoặc bị lỗi.

**Sửa:** Chạy thủ công từng bước để xem lỗi ở đâu:

```powershell
cd frontend
bun run build.client
bun run build.preview
bun prerender.mjs
cd ..
```

---

### Lỗi CORS (khi dev — 2 port riêng biệt)

**Triệu chứng:** Console trình duyệt hiện `CORS policy: No 'Access-Control-Allow-Origin'`

**Nguyên nhân:** `ALLOWED_ORIGIN` trong `backend/.env` không khớp với URL frontend.

**Sửa:** Đảm bảo `ALLOWED_ORIGIN=http://localhost:5173` trong `backend/.env`. Restart backend.

> Khi deploy ngrok (1 tunnel), CORS không xảy ra vì frontend và backend cùng origin.

---

### Lỗi: "Sai mat khau cho nickname nay"

**Nguyên nhân:** Nickname đã được tạo trước với mật khẩu khác.

**Sửa:** Chọn nickname khác, hoặc nhập đúng mật khẩu đã đặt lần đầu.

---

### Lỗi: "Khong nhan duoc auth message"

**Nguyên nhân:** Frontend gửi auth message quá chậm (timeout 10 giây).

**Sửa:** Reload trang, thử lại. Nếu vẫn lỗi, kiểm tra kết nối mạng.

---

### Lỗi: Frontend không kết nối được WebSocket

**Kiểm tra:**

1. Backend đang chạy? (`cargo run`)
2. Đúng URL? (`frontend/.env` trỏ đúng port 3000)
3. Nếu dùng ngrok: frontend tự chuyển `https://` → `wss://` cho WebSocket

---

### Reset toàn bộ dữ liệu

```powershell
cd backend
# Ctrl+C để dừng backend trước
del chat.db
cargo run
# DB mới được tạo, tất cả phòng/tin nhắn/user bị xóa
```