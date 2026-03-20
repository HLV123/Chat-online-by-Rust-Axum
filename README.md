# QwikChat

Ứng dụng chat ẩn danh thời gian thực. Không cần đăng ký — chỉ cần đặt nickname, tạo phòng và chat ngay.

---

## Tính năng

- **Chat real-time** qua WebSocket, cập nhật tức thì không cần reload
- **Nickname + mật khẩu** — tự tạo lần đầu, bảo vệ bằng bcrypt
- **Phòng có mật khẩu** — ai biết mật khẩu mới xóa được phòng
- **Reply tin nhắn** — trích dẫn kèm preview
- **Typing indicator** — hiện khi người khác đang nhập
- **Unread badge** — tự động nhảy phòng + đếm tin chưa đọc
- **Draft per-room** — lưu nội dung đang nhập khi chuyển phòng
- **Auto reconnect** — tự kết nối lại khi mất mạng (exponential backoff)
- **Online tracking** — chấm xanh theo heartbeat 30 giây

---

## Tech Stack

| Phần | Công nghệ |
|------|-----------|
| Frontend | [Qwik](https://qwik.dev/) + JS + TS |
| Styling | Tailwind CSS |
| Build tool | Vite + Bun |
| Backend | Rust + [Axum](https://github.com/tokio-rs/axum) |
| Database | SQLite (via rusqlite) |
| Auth | bcrypt |
| Real-time | WebSocket (tokio broadcast) |
| Static serving | tower-http ServeDir |
| Deploy | ngrok |

---

## Cấu trúc

```
qwikchat/
├── backend/        # Rust/Axum — REST API + WebSocket + serve static
└── frontend/       # Qwik — UI, build ra dist/ copy vào backend/public/
```



Xem `hướng_dẫn.md` để biết chi tiết từng bước.
