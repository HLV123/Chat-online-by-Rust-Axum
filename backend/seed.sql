-- ============================================================
-- QwikChat - Du lieu mau (Seed Data)
-- Chay: sqlite3 chat.db < seed.sql
-- ============================================================

-- Xoa du lieu cu (reset)
DELETE FROM messages;
DELETE FROM room_members;
DELETE FROM rooms;

-- ============================================================
-- PHONG CHAT (15 phong)
-- ============================================================

INSERT INTO rooms (id, name, description, created_by, created_at) VALUES
  ('room_001', 'Phong Chung', 'Phong chat chung cho moi nguoi, thoai mai tro chuyen', 'Admin', '2026-03-01 08:00:00'),
  ('room_002', 'Hoc Tap CNTT', 'Thao luan bai tap, on thi cac mon Cong nghe Thong tin', 'SinhVien_Minh', '2026-03-01 09:15:00'),
  ('room_003', 'Giai Tri', 'Noi chuyen vui ve, chia se nhac phim game', 'Nguoi_La_42', '2026-03-02 10:30:00'),
  ('room_004', 'Mang May Tinh', 'Hoi dap mon Mang may tinh - Thay Hung', 'SV_Lan', '2026-03-03 07:45:00'),
  ('room_005', 'Lap Trinh Web', 'React, Vue, Angular, Qwik - Thao luan tat ca', 'DevThanh', '2026-03-03 14:00:00'),
  ('room_006', 'Tim Viec IT', 'Chia se co hoi viec lam, thuc tap IT tai TPHCM va Ha Noi', 'HRNgoc', '2026-03-04 08:30:00'),
  ('room_007', 'Game Thu', 'Valorant, LOL, PUBG, Genshin - Tim dong doi', 'ProGamer_99', '2026-03-04 20:00:00'),
  ('room_008', 'Tieng Anh Giao Tiep', 'Practice English together - No judgment!', 'Teacher_Mai', '2026-03-05 06:00:00'),
  ('room_009', 'Rust Programming', 'Hoc Rust tu co ban den nang cao, chia se kinh nghiem', 'Rustacean_VN', '2026-03-05 15:00:00'),
  ('room_010', 'Do An Tot Nghiep', 'Ho tro nhau lam do an, chia se tai lieu va kinh nghiem', 'SV_Phuc', '2026-03-06 09:00:00'),
  ('room_011', 'Tin Tuc Cong Nghe', 'Cap nhat tin tuc tech moi nhat hang ngay', 'TechNews_Bot', '2026-03-06 12:00:00'),
  ('room_012', 'Phong Nhac', 'Chia se nhac hay, playlist cuoi tuan', 'DJ_Minh', '2026-03-07 21:00:00'),
  ('room_013', 'Co So Du Lieu', 'Thao luan SQL, NoSQL, thiet ke database', 'DBA_Long', '2026-03-08 10:00:00'),
  ('room_014', 'Khoi Nghiep Startup', 'Chia se y tuong, tim co-founder, goi von', 'Founder_Hieu', '2026-03-09 08:00:00');

-- ============================================================
-- TIN NHAN - PHONG CHUNG (room_001) - 40 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_001', 'Admin', 'Chao mung tat ca moi nguoi den voi QwikChat! Day la phong chat chung.', '2026-03-01 08:00:30'),
  ('room_001', 'Admin', 'Moi nguoi co the thoai mai tro chuyen, giu van minh nhe!', '2026-03-01 08:01:00'),
  ('room_001', 'Nguoi_La_42', 'Xin chao moi nguoi! Minh moi vao day', '2026-03-01 08:15:00'),
  ('room_001', 'SinhVien_Minh', 'Chao ban! App nay chat nhanh that', '2026-03-01 08:16:00'),
  ('room_001', 'Nguoi_La_42', 'Uh, khong can dang ky gi luan, thich qua', '2026-03-01 08:16:30'),
  ('room_001', 'DevThanh', 'App xai WebSocket nen real-time lam', '2026-03-01 08:20:00'),
  ('room_001', 'SV_Lan', 'Hello moi nguoi! Minh la sinh vien CNTT nam 4', '2026-03-01 09:00:00'),
  ('room_001', 'HackerCool', 'Ai biet cach deploy app len server khong chi minh voi', '2026-03-01 09:30:00'),
  ('room_001', 'DevThanh', 'Ban dung ngrok la duoc, tunnel localhost ra internet', '2026-03-01 09:31:00'),
  ('room_001', 'HackerCool', 'Oh hay qua, de minh thu. Cam on ban!', '2026-03-01 09:32:00'),
  ('room_001', 'Nguoi_La_88', 'Moi nguoi oi, hom nay thoi tiet dep qua', '2026-03-01 10:00:00'),
  ('room_001', 'SinhVien_Minh', 'Ha Noi hom nay mua roi ban oi 😭', '2026-03-01 10:01:00'),
  ('room_001', 'Nguoi_La_88', 'Minh o Sai Gon, nang dep lam', '2026-03-01 10:02:00'),
  ('room_001', 'Admin', 'Nhac moi nguoi: Phong chat se tu dong xoa tin nhan cu hon 30 ngay nhe', '2026-03-01 12:00:00'),
  ('room_001', 'CodingGirl', 'Moi nguoi co ai dang hoc React khong?', '2026-03-01 14:00:00'),
  ('room_001', 'DevThanh', 'Minh dang hoc Qwik, tuong tu React nhung nhanh hon', '2026-03-01 14:05:00'),
  ('room_001', 'CodingGirl', 'Qwik la gi vay? Minh chua nghe bao gio', '2026-03-01 14:06:00'),
  ('room_001', 'DevThanh', 'Framework cua Builder.io, dung resumability thay vi hydration', '2026-03-01 14:07:00'),
  ('room_001', 'CodingGirl', 'Nghe hay do, de minh tim hieu them. Thanks!', '2026-03-01 14:08:00'),
  ('room_001', 'Nguoi_La_123', 'Co ai choi bong da chieu nay khong', '2026-03-01 15:00:00'),
  ('room_001', 'SV_Lan', 'Minh khong choi bong da nhung co xem K+ 😄', '2026-03-01 15:05:00'),
  ('room_001', 'ProGamer_99', 'Bong da chan roi, choi game di', '2026-03-01 15:10:00'),
  ('room_001', 'Nguoi_La_123', 'Game gi vay ban?', '2026-03-01 15:11:00'),
  ('room_001', 'ProGamer_99', 'Valorant do, sang phong Game Thu chat nhe', '2026-03-01 15:12:00'),
  ('room_001', 'MidnightOwl', 'Co ai con thuc khong nhi', '2026-03-01 23:30:00'),
  ('room_001', 'Anon_777', 'Minh day! Dang code do an', '2026-03-01 23:35:00'),
  ('room_001', 'MidnightOwl', 'Code gi vay? Minh cung dang lam bai', '2026-03-01 23:36:00'),
  ('room_001', 'Anon_777', 'Lam web chat bang Rust + Qwik ne', '2026-03-01 23:37:00'),
  ('room_001', 'MidnightOwl', 'Rust a? Kho khong ban?', '2026-03-01 23:38:00'),
  ('room_001', 'Anon_777', 'Ban dau kho nhung quen roi thich lam, nhanh va an toan', '2026-03-01 23:39:00'),
  ('room_001', 'Admin', 'Chao buoi sang! Chuc moi nguoi ngay moi vui ve!', '2026-03-02 07:00:00'),
  ('room_001', 'SinhVien_Minh', 'Chao admin! Hom nay di hoc som qua', '2026-03-02 07:15:00'),
  ('room_001', 'CoffeeAddict', 'Chua uong ca phe la chua tinh ngu', '2026-03-02 07:20:00'),
  ('room_001', 'SV_Lan', 'Minh cung vay, phai co ly ca phe moi lam viec duoc', '2026-03-02 07:22:00'),
  ('room_001', 'Nguoi_La_42', 'Minh thi uong tra da thoi, ca phe mat ngu', '2026-03-02 07:25:00'),
  ('room_001', 'FoodieVN', 'Ai biet cho an sang ngon o quan 1 khong?', '2026-03-02 08:00:00'),
  ('room_001', 'Nguoi_La_88', 'Banh mi Huynh Hoa do ban, ngon nuc tieng', '2026-03-02 08:02:00'),
  ('room_001', 'FoodieVN', 'Cai do xep hang dai lam, co cho nao bot dong khong', '2026-03-02 08:03:00'),
  ('room_001', 'SV_Lan', 'Thu banh mi 37 Nguyen Trai di, cung ngon ma it nguoi hon', '2026-03-02 08:05:00'),
  ('room_001', 'FoodieVN', 'Ok de minh thu. Cam on nha!', '2026-03-02 08:06:00');

-- ============================================================
-- TIN NHAN - HOC TAP CNTT (room_002) - 35 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_002', 'SinhVien_Minh', 'Chao moi nguoi! Day la phong thao luan hoc tap CNTT', '2026-03-01 09:15:30'),
  ('room_002', 'SinhVien_Minh', 'Ai co tai lieu mon Cau Truc Du Lieu khong chia se voi', '2026-03-01 09:16:00'),
  ('room_002', 'SV_Lan', 'Minh co slide cua thay Hung, de minh tim lai', '2026-03-01 09:20:00'),
  ('room_002', 'SV_Nam', 'Thay Hung day mon nao vay?', '2026-03-01 09:21:00'),
  ('room_002', 'SV_Lan', 'Thay day CTDL va Giai thuat, giang rat de hieu', '2026-03-01 09:22:00'),
  ('room_002', 'CodeNewbie', 'Moi nguoi oi, binary search tree la gi vay? Minh doc sach khong hieu', '2026-03-01 10:00:00'),
  ('room_002', 'SinhVien_Minh', 'BST la cay nhi phan tim kiem, node trai nho hon, node phai lon hon', '2026-03-01 10:02:00'),
  ('room_002', 'SV_Lan', 'Ban search YouTube kenh "Ong Dev" co giai thich rat truc quan', '2026-03-01 10:03:00'),
  ('room_002', 'CodeNewbie', 'Ok thanks moi nguoi! Minh se xem', '2026-03-01 10:05:00'),
  ('room_002', 'AlgoKing', 'Ai giai duoc bai Leetcode 42 (Trapping Rain Water) chua?', '2026-03-01 11:00:00'),
  ('room_002', 'SinhVien_Minh', 'Bai do dung two pointers hoac stack deu duoc', '2026-03-01 11:05:00'),
  ('room_002', 'AlgoKing', 'Minh dung stack ma bi Time Limit, chac implement sai', '2026-03-01 11:06:00'),
  ('room_002', 'DevThanh', 'Dung two pointers cho O(1) space, code ngan hon nua', '2026-03-01 11:10:00'),
  ('room_002', 'SV_Nam', 'Tuan sau thi giua ky OOP roi, ai on chua?', '2026-03-02 08:00:00'),
  ('room_002', 'SV_Lan', 'Chua, dang hoang lam 😱 Ai co de thi cu khong?', '2026-03-02 08:05:00'),
  ('room_002', 'SinhVien_Minh', 'Minh co de nam ngoai, 4 cau: ke thua, da hinh, abstract, interface', '2026-03-02 08:10:00'),
  ('room_002', 'SV_Nam', 'Gui minh voi! Cam on truoc nhe', '2026-03-02 08:11:00'),
  ('room_002', 'SV_Lan', 'Minh cung can, xin link luon', '2026-03-02 08:12:00'),
  ('room_002', 'SinhVien_Minh', 'De minh up len drive roi gui link cho', '2026-03-02 08:15:00'),
  ('room_002', 'DBStudent', 'Co ai biet cach normalize database len 3NF khong?', '2026-03-02 14:00:00'),
  ('room_002', 'SinhVien_Minh', '3NF la moi thuoc tinh non-key phu thuoc truc tiep vao khoa chinh', '2026-03-02 14:05:00'),
  ('room_002', 'DBA_Long', 'Dung roi. Buoc 1: Xac dinh FD, Buoc 2: Phan ra, Buoc 3: Kiem tra', '2026-03-02 14:10:00'),
  ('room_002', 'DBStudent', 'Cam on 2 ban! Minh dang bi stuck o buoc phan ra', '2026-03-02 14:12:00'),
  ('room_002', 'DBA_Long', 'Ban post cau hoi cu the len day minh chi cho', '2026-03-02 14:15:00'),
  ('room_002', 'WebDev_01', 'Moi nguoi co ai biet cach deploy React len Vercel khong?', '2026-03-03 09:00:00'),
  ('room_002', 'DevThanh', 'De lam, push code len GitHub roi connect Vercel la xong', '2026-03-03 09:05:00'),
  ('room_002', 'WebDev_01', 'Vercel co tinh phi khong?', '2026-03-03 09:06:00'),
  ('room_002', 'DevThanh', 'Free cho project ca nhan, du xai roi', '2026-03-03 09:07:00'),
  ('room_002', 'SV_Lan', 'Ai co kinh nghiem lam do an bang Python Django khong?', '2026-03-03 16:00:00'),
  ('room_002', 'PythonFan', 'Minh lam roi, Django kha tot cho web app, co ORM san', '2026-03-03 16:10:00'),
  ('room_002', 'SV_Lan', 'Ban lam mat bao lau?', '2026-03-03 16:12:00'),
  ('room_002', 'PythonFan', 'Khoang 2 thang, bao gom ca hoc Django', '2026-03-03 16:15:00'),
  ('room_002', 'SV_Lan', 'OK minh se can nhac. Cam on ban!', '2026-03-03 16:16:00'),
  ('room_002', 'SinhVien_Minh', 'Minh goi y Rust + Axum cho backend, hieu nang tot lam', '2026-03-03 16:20:00'),
  ('room_002', 'SV_Lan', 'Rust kho qua, minh moi hoc lap trinh co ban thoi 😅', '2026-03-03 16:22:00');

-- ============================================================
-- TIN NHAN - GIAI TRI (room_003) - 30 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_003', 'Nguoi_La_42', 'Welcome to Giai Tri room! Noi chuyen gi cung duoc', '2026-03-02 10:30:30'),
  ('room_003', 'MovieFan', 'Ai xem Dune 3 chua? Hay qua troi', '2026-03-02 11:00:00'),
  ('room_003', 'Nguoi_La_42', 'Chua, con chieu o rap khong?', '2026-03-02 11:02:00'),
  ('room_003', 'MovieFan', 'Con nhe, tuan nay la tuan cuoi roi', '2026-03-02 11:03:00'),
  ('room_003', 'AnimeWeeb', 'Minh thi dang xem Jujutsu Kaisen season 3, hype qua', '2026-03-02 11:10:00'),
  ('room_003', 'Nguoi_La_42', 'JJK season 3 ra roi a? Minh chua biet', '2026-03-02 11:12:00'),
  ('room_003', 'AnimeWeeb', 'Roi ban, tren Crunchyroll co roi. Tap 1 dinh lam', '2026-03-02 11:13:00'),
  ('room_003', 'MusicLover', 'Ai nghe nhac gi dang hay khong chia se voi', '2026-03-02 14:00:00'),
  ('room_003', 'DJ_Minh', 'Minh dang nghe album moi cua Mono, nhac chill lam', '2026-03-02 14:05:00'),
  ('room_003', 'MusicLover', 'Mono hat hay that, "Waiting for you" nghe hoai khong chan', '2026-03-02 14:07:00'),
  ('room_003', 'Nguoi_La_88', 'Team nhac US rap co ai khong, Drake vua ra album moi', '2026-03-02 14:10:00'),
  ('room_003', 'ProGamer_99', 'Moi nguoi co choi Palworld khong? Vui lam', '2026-03-02 18:00:00'),
  ('room_003', 'GameNewbie', 'Palworld la gi vay?', '2026-03-02 18:05:00'),
  ('room_003', 'ProGamer_99', 'Kieu nhu Pokemon + Minecraft + ban sung, rat la hay', '2026-03-02 18:06:00'),
  ('room_003', 'GameNewbie', 'Nghe interesting, co tren Steam khong?', '2026-03-02 18:07:00'),
  ('room_003', 'ProGamer_99', 'Co ban, dang sale nua, mua di', '2026-03-02 18:08:00'),
  ('room_003', 'BookWorm', 'Moi nguoi co ai doc sach khong? Minh vua doc xong "Atomic Habits"', '2026-03-03 09:00:00'),
  ('room_003', 'CoffeeAddict', 'Sach do hay lam! Minh doc nam ngoai, giup thay doi nhieu thoi quen', '2026-03-03 09:10:00'),
  ('room_003', 'BookWorm', 'Dung, dac biet phan ve "habit stacking" rat hay', '2026-03-03 09:12:00'),
  ('room_003', 'Nguoi_La_42', 'Cho minh goi y sach tiep di', '2026-03-03 09:15:00'),
  ('room_003', 'BookWorm', '"Deep Work" cua Cal Newport cung rat dinh', '2026-03-03 09:16:00'),
  ('room_003', 'FoodieVN', 'Cuoi tuan nay ai di an gi chua? Minh tim cho an lau', '2026-03-03 17:00:00'),
  ('room_003', 'Nguoi_La_88', 'Lau Hai San o quan 7 ngon lam, ten la "Ong Beo"', '2026-03-03 17:05:00'),
  ('room_003', 'FoodieVN', 'Co dat truoc duoc khong?', '2026-03-03 17:06:00'),
  ('room_003', 'Nguoi_La_88', 'Dat qua Grab duoc nhe, hoac goi dien truc tiep', '2026-03-03 17:07:00'),
  ('room_003', 'MovieFan', 'Toi nay ai xem phim gi khong? Netflix co phim moi hay', '2026-03-03 20:00:00'),
  ('room_003', 'AnimeWeeb', 'Minh xem anime thoi, Netflix anime it qua', '2026-03-03 20:05:00'),
  ('room_003', 'MovieFan', 'Netflix co One Piece live action season 2 do', '2026-03-03 20:06:00'),
  ('room_003', 'AnimeWeeb', 'That a?! De minh check ngay', '2026-03-03 20:07:00'),
  ('room_003', 'Nguoi_La_42', 'Chuc moi nguoi cuoi tuan vui ve! 🎉', '2026-03-03 23:00:00');

-- ============================================================
-- TIN NHAN - MANG MAY TINH (room_004) - 25 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_004', 'SV_Lan', 'Phong thao luan mon Mang may tinh - Thay Hung', '2026-03-03 07:45:30'),
  ('room_004', 'SV_Nam', 'Bai tap tuan nay kho qua, ai lam chua?', '2026-03-03 08:00:00'),
  ('room_004', 'SV_Lan', 'Bai nao? Bai subnet mask a?', '2026-03-03 08:02:00'),
  ('room_004', 'SV_Nam', 'Uh, phai chia subnet cho 4 phong ban, 50 may moi phong', '2026-03-03 08:03:00'),
  ('room_004', 'NetworkPro', 'Bai do dung /26 la vua, moi subnet 62 host', '2026-03-03 08:10:00'),
  ('room_004', 'SV_Nam', 'Sao lai /26? Minh tinh ra /25', '2026-03-03 08:12:00'),
  ('room_004', 'NetworkPro', '/25 thi 126 host, du nhung phung phi. /26 = 64 - 2 = 62 host, vua du', '2026-03-03 08:15:00'),
  ('room_004', 'SV_Lan', 'A hieu roi, tru di network address va broadcast', '2026-03-03 08:16:00'),
  ('room_004', 'SV_Nam', 'Cam on ban nhieu! Gio minh hieu roi', '2026-03-03 08:20:00'),
  ('room_004', 'SV_Tuan', 'Ai biet su khac nhau giua TCP va UDP khong?', '2026-03-03 10:00:00'),
  ('room_004', 'NetworkPro', 'TCP: tin cay, co ket noi, cham hon. UDP: khong tin cay, nhanh hon', '2026-03-03 10:05:00'),
  ('room_004', 'SV_Lan', 'Video call dung UDP, web browsing dung TCP', '2026-03-03 10:06:00'),
  ('room_004', 'SV_Tuan', 'WebSocket thi dung TCP hay UDP?', '2026-03-03 10:08:00'),
  ('room_004', 'NetworkPro', 'WebSocket chay tren TCP, bat dau bang HTTP handshake roi upgrade', '2026-03-03 10:10:00'),
  ('room_004', 'SV_Tuan', 'Hay qua, tuc la app chat nay dang dung TCP dong?', '2026-03-03 10:12:00'),
  ('room_004', 'NetworkPro', 'Dung roi! WebSocket = full-duplex TCP connection', '2026-03-03 10:13:00'),
  ('room_004', 'SV_Lan', 'OSI 7 tang ai nho du khong? Minh hay quen tang 5 6', '2026-03-03 14:00:00'),
  ('room_004', 'SV_Nam', 'Physical, Data Link, Network, Transport, Session, Presentation, Application', '2026-03-03 14:05:00'),
  ('room_004', 'SV_Lan', 'Cam on! Minh hay nho bang cau: "Please Do Not Throw Sausage Pizza Away"', '2026-03-03 14:07:00'),
  ('room_004', 'NetworkPro', 'Hay, minh thi nho: "All People Seem To Need Data Processing" (tu tren xuong)', '2026-03-03 14:10:00'),
  ('room_004', 'SV_Tuan', 'DNS hoat dong nhu the nao vay moi nguoi?', '2026-03-03 16:00:00'),
  ('room_004', 'NetworkPro', 'DNS chuyen domain (google.com) thanh IP (142.250.x.x). Nhu danh ba dien thoai', '2026-03-03 16:05:00'),
  ('room_004', 'SV_Tuan', 'Neu DNS chet thi sao?', '2026-03-03 16:07:00'),
  ('room_004', 'NetworkPro', 'Khong vao web bang ten mien duoc, phai go IP truc tiep. Nen co nhieu DNS server', '2026-03-03 16:10:00'),
  ('room_004', 'SV_Lan', 'Buoi hoc ngay mai thay Hung co bao on gi khong nhi?', '2026-03-03 20:00:00');

-- ============================================================
-- TIN NHAN - LAP TRINH WEB (room_005) - 30 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_005', 'DevThanh', 'Chao mung den phong Lap Trinh Web! React, Vue, Qwik, bat cu gi', '2026-03-03 14:00:30'),
  ('room_005', 'ReactDev', 'React 19 co gi moi khong moi nguoi?', '2026-03-03 14:30:00'),
  ('room_005', 'DevThanh', 'React 19 co Server Components, use() hook moi, cai thien performance', '2026-03-03 14:35:00'),
  ('room_005', 'VueFan', 'Vue 3 van tot hon React ve DX (Developer Experience) 😄', '2026-03-03 14:40:00'),
  ('room_005', 'ReactDev', 'Tuy quan diem thoi, React ecosystem lon hon nhieu', '2026-03-03 14:42:00'),
  ('room_005', 'DevThanh', 'Minh thi thich Qwik, resumability > hydration', '2026-03-03 14:45:00'),
  ('room_005', 'WebNewbie', 'Moi nguoi oi, minh moi hoc web, nen bat dau tu dau?', '2026-03-04 09:00:00'),
  ('room_005', 'DevThanh', 'HTML + CSS + JavaScript co ban truoc, roi hoc framework sau', '2026-03-04 09:05:00'),
  ('room_005', 'ReactDev', 'Dung, co ban vung roi hoc React/Vue se nhanh lam', '2026-03-04 09:07:00'),
  ('room_005', 'WebNewbie', 'Hoc mat bao lau de co the xin viec duoc?', '2026-03-04 09:10:00'),
  ('room_005', 'VueFan', 'Khoang 6 thang - 1 nam neu hoc nghiem tuc', '2026-03-04 09:12:00'),
  ('room_005', 'DevThanh', 'Quan trong la lam project thuc te, dung chi xem tutorial', '2026-03-04 09:15:00'),
  ('room_005', 'TailwindLover', 'Ai dung Tailwind CSS khong? Minh thay tien lam', '2026-03-04 15:00:00'),
  ('room_005', 'ReactDev', 'Tailwind + React la combo dinh cua dinh', '2026-03-04 15:05:00'),
  ('room_005', 'VueFan', 'Minh thi thich CSS modules hon, Tailwind class dai qua', '2026-03-04 15:07:00'),
  ('room_005', 'TailwindLover', 'Quen roi thi code rat nhanh, khong can switch file', '2026-03-04 15:10:00'),
  ('room_005', 'FullstackDev', 'Backend moi nguoi dung gi? Minh dang phan van Node vs Rust', '2026-03-05 10:00:00'),
  ('room_005', 'DevThanh', 'Rust performance tot hon nhieu, nhung learning curve cao', '2026-03-05 10:05:00'),
  ('room_005', 'ReactDev', 'Node de hon cho nguoi moi, ecosystem lon', '2026-03-05 10:07:00'),
  ('room_005', 'FullstackDev', 'Minh muon hoc Rust lau dai, nhung deadline gap qua', '2026-03-05 10:10:00'),
  ('room_005', 'DevThanh', 'Vay dung Node truoc cho xong, roi hoc Rust sau', '2026-03-05 10:12:00'),
  ('room_005', 'NextJSDev', 'Ai dung Next.js 15 chua? App router hay lam', '2026-03-05 16:00:00'),
  ('room_005', 'ReactDev', 'Next.js 15 + RSC rat manh, SEO tot', '2026-03-05 16:05:00'),
  ('room_005', 'VueFan', 'Nuxt 3 cung tuong tu, nhung cho Vue', '2026-03-05 16:07:00'),
  ('room_005', 'DevThanh', 'Qwik City tuong tu Next.js nhung khong can hydration', '2026-03-05 16:10:00'),
  ('room_005', 'WebNewbie', 'Gio nhieu framework qua, chon cai nao day?', '2026-03-05 16:12:00'),
  ('room_005', 'DevThanh', 'Chon 1 cai va master no, dung nhay lung tung', '2026-03-05 16:15:00'),
  ('room_005', 'ReactDev', 'React van la lua chon an toan nhat cho viec lam', '2026-03-05 16:17:00'),
  ('room_005', 'VueFan', 'Vue cung nhieu viec o VN lam nhe', '2026-03-05 16:18:00'),
  ('room_005', 'FullstackDev', 'Cam on moi nguoi, minh se hoc React truoc!', '2026-03-05 16:20:00');

-- ============================================================
-- TIN NHAN - TIM VIEC IT (room_006) - 25 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_006', 'HRNgoc', 'Chao moi nguoi! Day la phong chia se co hoi viec lam IT', '2026-03-04 08:30:30'),
  ('room_006', 'HRNgoc', 'Cong ty minh dang tuyen Frontend Dev (React), luong 15-25tr, TPHCM', '2026-03-04 08:31:00'),
  ('room_006', 'FreshGrad', 'Fresher co duoc apply khong chi?', '2026-03-04 09:00:00'),
  ('room_006', 'HRNgoc', 'Co ban, can biet React co ban va co project ca nhan', '2026-03-04 09:05:00'),
  ('room_006', 'FreshGrad', 'Minh co 2 project React tren GitHub, gui CV qua dau a?', '2026-03-04 09:07:00'),
  ('room_006', 'HRNgoc', 'Gui qua email hr@techcorp.vn nhe, ghi "Frontend Dev - QwikChat"', '2026-03-04 09:10:00'),
  ('room_006', 'SeniorDev', 'Cong ty minh cung dang tuyen Backend Golang, remote, 30-50tr', '2026-03-04 10:00:00'),
  ('room_006', 'DevThanh', 'Golang a? Can bao nhieu nam kinh nghiem?', '2026-03-04 10:05:00'),
  ('room_006', 'SeniorDev', 'Tu 2 nam tro len, biet Docker va K8s la plus', '2026-03-04 10:07:00'),
  ('room_006', 'JobSeeker_01', 'Internship IT co ai biet cho nao tuyen khong?', '2026-03-04 14:00:00'),
  ('room_006', 'HRNgoc', 'FPT, Viettel, VNG deu co chuong trinh thuc tap mua he', '2026-03-04 14:05:00'),
  ('room_006', 'JobSeeker_01', 'FPT co luong thuc tap khong?', '2026-03-04 14:07:00'),
  ('room_006', 'SeniorDev', 'Co, khoang 3-5 trieu/thang tuy vi tri', '2026-03-04 14:10:00'),
  ('room_006', 'CVHelper', 'Moi nguoi oi, viet CV IT nen co nhung gi?', '2026-03-05 08:00:00'),
  ('room_006', 'HRNgoc', 'Project ca nhan (GitHub link), ky nang ky thuat, hoc van. Khong can hinh', '2026-03-05 08:10:00'),
  ('room_006', 'SeniorDev', 'Quan trong nhat la project thuc te, nha tuyen dung xem code tren GitHub', '2026-03-05 08:12:00'),
  ('room_006', 'CVHelper', 'GitHub minh chua co gi, nen bat dau tu dau?', '2026-03-05 08:15:00'),
  ('room_006', 'DevThanh', 'Lam 2-3 project nho: todo app, weather app, portfolio website', '2026-03-05 08:20:00'),
  ('room_006', 'HRNgoc', 'Dung, co portfolio website la diem cong rat lon', '2026-03-05 08:22:00'),
  ('room_006', 'RemoteWorker', 'Ai lam remote o VN cho cong ty nuoc ngoai khong? Luong the nao?', '2026-03-05 15:00:00'),
  ('room_006', 'SeniorDev', 'Minh lam remote cho startup My, luong 2000-3000 USD/thang cho mid-level', '2026-03-05 15:05:00'),
  ('room_006', 'RemoteWorker', 'Wow, tim tren dau vay?', '2026-03-05 15:07:00'),
  ('room_006', 'SeniorDev', 'LinkedIn, Remote.co, We Work Remotely, TopTal', '2026-03-05 15:10:00'),
  ('room_006', 'FreshGrad', 'Anh oi, fresher co xin remote duoc khong?', '2026-03-05 15:12:00'),
  ('room_006', 'SeniorDev', 'Kho hon, nen lam office 1-2 nam roi chuyen remote', '2026-03-05 15:15:00');

-- ============================================================
-- TIN NHAN - GAME THU (room_007) - 25 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_007', 'ProGamer_99', 'Phong Game Thu da mo! Choi gi cung duoc', '2026-03-04 20:00:30'),
  ('room_007', 'ValorantPro', 'Ai rank Valorant bao nhieu roi?', '2026-03-04 20:10:00'),
  ('room_007', 'ProGamer_99', 'Minh Platinum 2, dang co len Diamond', '2026-03-04 20:12:00'),
  ('room_007', 'ValorantPro', 'Minh Diamond 1, choi duo khong?', '2026-03-04 20:13:00'),
  ('room_007', 'ProGamer_99', 'OK luan! Add minh: ProGamer#VN99', '2026-03-04 20:14:00'),
  ('room_007', 'LOLPlayer', 'Ai choi LOL khong? Minh can support', '2026-03-04 21:00:00'),
  ('room_007', 'SupportMain', 'Minh main support nhe, rank Gold 3', '2026-03-04 21:05:00'),
  ('room_007', 'LOLPlayer', 'OK luon, minh ADC Gold 2. Phoi hop nhe!', '2026-03-04 21:06:00'),
  ('room_007', 'GenshinFan', 'Version moi Genshin co gi hay khong moi nguoi?', '2026-03-05 10:00:00'),
  ('room_007', 'ProGamer_99', 'Banner moi la Clorinde rerun, nen pull', '2026-03-05 10:05:00'),
  ('room_007', 'GenshinFan', 'Minh het primo roi 😭 F2P kho qua', '2026-03-05 10:07:00'),
  ('room_007', 'PUBGMaster', 'PUBG Mobile co ai choi khong? Rank Conqueror day', '2026-03-05 18:00:00'),
  ('room_007', 'ProGamer_99', 'PUBG minh cung choi, nhung rank Crown thoi', '2026-03-05 18:05:00'),
  ('room_007', 'PUBGMaster', 'Choi chung de minh keo rank cho', '2026-03-05 18:06:00'),
  ('room_007', 'MinecraftKid', 'Ai choi Minecraft Survival khong? Minh co server', '2026-03-06 14:00:00'),
  ('room_007', 'ProGamer_99', 'Minecraft a? IP server bao nhieu?', '2026-03-06 14:05:00'),
  ('room_007', 'MinecraftKid', 'mc.vnserver.net, version 1.20.4', '2026-03-06 14:06:00'),
  ('room_007', 'ValorantPro', 'Toi nay co ai ranked Valorant khong? 9h nhe', '2026-03-06 19:00:00'),
  ('room_007', 'ProGamer_99', 'Co minh! 9h sharp nhe', '2026-03-06 19:05:00'),
  ('room_007', 'AimGod', 'Minh cung vao, rank Immortal 1', '2026-03-06 19:10:00'),
  ('room_007', 'ValorantPro', 'Wow Immortal lun, carry minh voi 🙏', '2026-03-06 19:11:00'),
  ('room_007', 'AimGod', 'OK choi vui thoi, khong toxic nhe', '2026-03-06 19:12:00'),
  ('room_007', 'GenshinFan', 'Ai co code redeem Genshin khong chia se voi', '2026-03-07 08:00:00'),
  ('room_007', 'ProGamer_99', 'Check HoYoLAB app, thuong co code moi moi patch', '2026-03-07 08:05:00'),
  ('room_007', 'GenshinFan', 'Thanks ban! Minh check ngay', '2026-03-07 08:06:00');

-- ============================================================
-- TIN NHAN - TIENG ANH GIAO TIEP (room_008) - 20 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_008', 'Teacher_Mai', 'Welcome everyone! This room is for practicing English. Feel free to chat!', '2026-03-05 06:00:30'),
  ('room_008', 'Teacher_Mai', 'No grammar police here, just practice and have fun 😊', '2026-03-05 06:01:00'),
  ('room_008', 'EnglishLearner1', 'Hello! My name is Hoa. I want to improve my speaking skill', '2026-03-05 07:00:00'),
  ('room_008', 'Teacher_Mai', 'Hi Hoa! Great to have you here. What do you do for living?', '2026-03-05 07:05:00'),
  ('room_008', 'EnglishLearner1', 'I am a IT student. I study at university in Ho Chi Minh City', '2026-03-05 07:07:00'),
  ('room_008', 'Teacher_Mai', 'Nice! Small tip: we say "an IT student" because IT starts with a vowel sound', '2026-03-05 07:10:00'),
  ('room_008', 'EnglishLearner1', 'Oh I see! Thank you teacher!', '2026-03-05 07:12:00'),
  ('room_008', 'IELTSPrep', 'Does anyone prepare for IELTS here?', '2026-03-05 10:00:00'),
  ('room_008', 'Teacher_Mai', 'I can help! What band score are you aiming for?', '2026-03-05 10:05:00'),
  ('room_008', 'IELTSPrep', 'I need band 6.5 for my scholarship application', '2026-03-05 10:07:00'),
  ('room_008', 'Teacher_Mai', 'That is achievable! Focus on Writing and Speaking, they are usually the weakest', '2026-03-05 10:10:00'),
  ('room_008', 'TechEnglish', 'How do you say "bien" in English in IT context?', '2026-03-05 14:00:00'),
  ('room_008', 'Teacher_Mai', 'Variable! "Bien" in programming is "variable"', '2026-03-05 14:05:00'),
  ('room_008', 'TechEnglish', 'And "mang" in programming?', '2026-03-05 14:06:00'),
  ('room_008', 'Teacher_Mai', 'Array! "Mang" is "array". Very common in programming', '2026-03-05 14:07:00'),
  ('room_008', 'EnglishLearner1', 'I have a question: What is difference between "make" and "do"?', '2026-03-05 16:00:00'),
  ('room_008', 'Teacher_Mai', 'Great question! "Make" = create something new. "Do" = perform an action', '2026-03-05 16:05:00'),
  ('room_008', 'Teacher_Mai', 'Make a cake, make a decision. Do homework, do exercise', '2026-03-05 16:06:00'),
  ('room_008', 'EnglishLearner1', 'Thank you! Now I understand better', '2026-03-05 16:10:00'),
  ('room_008', 'Teacher_Mai', 'Keep practicing everyone! See you tomorrow!', '2026-03-05 21:00:00');

-- ============================================================
-- TIN NHAN - RUST PROGRAMMING (room_009) - 20 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_009', 'Rustacean_VN', 'Chao mung den phong Rust! Ownership, Borrowing, Lifetime', '2026-03-05 15:00:30'),
  ('room_009', 'RustNewbie', 'Minh moi bat dau hoc Rust, ownership la gi vay?', '2026-03-05 15:30:00'),
  ('room_009', 'Rustacean_VN', 'Ownership la he thong quan ly memory cua Rust, moi gia tri chi co 1 owner', '2026-03-05 15:35:00'),
  ('room_009', 'RustNewbie', 'Khac gi voi garbage collector?', '2026-03-05 15:37:00'),
  ('room_009', 'Rustacean_VN', 'GC chay luc runtime (cham). Rust check luc compile (0 cost runtime)', '2026-03-05 15:40:00'),
  ('room_009', 'AxumDev', 'Ai dung Axum cho web server chua? So voi Actix web the nao?', '2026-03-06 09:00:00'),
  ('room_009', 'Rustacean_VN', 'Axum don gian hon, ecosystem tot (cung team Tokio). Actix nhanh hon 1 chut', '2026-03-06 09:05:00'),
  ('room_009', 'AxumDev', 'Axum co ho tro WebSocket khong?', '2026-03-06 09:07:00'),
  ('room_009', 'Rustacean_VN', 'Co! axum::extract::ws, rat de dung', '2026-03-06 09:10:00'),
  ('room_009', 'CrabLover', 'Minh vua fix duoc lifetime error, mat 2 tieng 😭', '2026-03-06 14:00:00'),
  ('room_009', 'Rustacean_VN', 'Binh thuong thoi, lifetime la phan kho nhat cua Rust', '2026-03-06 14:05:00'),
  ('room_009', 'CrabLover', 'Compiler bao "does not live long enough", debug muon dien', '2026-03-06 14:07:00'),
  ('room_009', 'RustNewbie', 'Tai sao Rust khong co null?', '2026-03-06 16:00:00'),
  ('room_009', 'Rustacean_VN', 'Thay bang Option<T>, buoc ban xu ly ca 2 truong hop Some va None', '2026-03-06 16:05:00'),
  ('room_009', 'AxumDev', 'Nho Option + Result ma Rust it bug hon nhieu ngon ngu khac', '2026-03-06 16:07:00'),
  ('room_009', 'RustNewbie', 'Sach nao tot de hoc Rust?', '2026-03-07 08:00:00'),
  ('room_009', 'Rustacean_VN', '"The Rust Programming Language" (The Book) la so 1, doc free online', '2026-03-07 08:05:00'),
  ('room_009', 'CrabLover', '"Rust by Example" cung hay, hoc qua vi du', '2026-03-07 08:07:00'),
  ('room_009', 'AxumDev', '"Zero To Production In Rust" cho ai muon lam web backend', '2026-03-07 08:10:00'),
  ('room_009', 'RustNewbie', 'Cam on moi nguoi! Minh se bat dau voi The Book', '2026-03-07 08:12:00');

-- ============================================================
-- TIN NHAN - DO AN TOT NGHIEP (room_010) - 20 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_010', 'SV_Phuc', 'Phong ho tro do an tot nghiep! Cung nhau vuot qua nhe', '2026-03-06 09:00:30'),
  ('room_010', 'DATN_Hoa', 'Minh dang lam do an ve AI chatbot, bi stuck o phan NLP', '2026-03-06 10:00:00'),
  ('room_010', 'SV_Phuc', 'Ban dung model gi? BERT hay GPT?', '2026-03-06 10:05:00'),
  ('room_010', 'DATN_Hoa', 'Dang dung PhoBERT cho tieng Viet', '2026-03-06 10:07:00'),
  ('room_010', 'AIStudent', 'PhoBERT tot cho tieng Viet, nhung can fine-tune chuyen nganh', '2026-03-06 10:10:00'),
  ('room_010', 'DATN_Long', 'Minh lam do an ve E-commerce, dung MERN stack', '2026-03-06 14:00:00'),
  ('room_010', 'SV_Phuc', 'MERN quen thuoc roi, phan nao kho nhat?', '2026-03-06 14:05:00'),
  ('room_010', 'DATN_Long', 'Payment integration, VNPay API phuc tap qua', '2026-03-06 14:07:00'),
  ('room_010', 'DevThanh', 'VNPay co SDK cho Node, doc docs tren sandbox truoc', '2026-03-06 14:10:00'),
  ('room_010', 'DATN_Linh', 'Ai lam do an bang Rust chua? Giang vien co chap nhan khong?', '2026-03-07 09:00:00'),
  ('room_010', 'SV_Phuc', 'Tuy giang vien, nhung Rust the hien trinh do ky thuat cao', '2026-03-07 09:05:00'),
  ('room_010', 'Rustacean_VN', 'Do an minh dung Rust + Axum + Qwik, thay khen rat nhieu', '2026-03-07 09:10:00'),
  ('room_010', 'DATN_Linh', 'Hay qua! Ban co chia se code tham khao duoc khong?', '2026-03-07 09:12:00'),
  ('room_010', 'Rustacean_VN', 'Duoc, minh se up len GitHub roi gui link', '2026-03-07 09:15:00'),
  ('room_010', 'SV_Phuc', 'Moi nguoi nho viet bao cao dung format, doc ky huong dan cua khoa', '2026-03-08 08:00:00'),
  ('room_010', 'DATN_Hoa', 'Bao cao co can UML diagram khong?', '2026-03-08 08:05:00'),
  ('room_010', 'SV_Phuc', 'Co, can Use Case, Class Diagram, Sequence Diagram', '2026-03-08 08:07:00'),
  ('room_010', 'DATN_Long', 'Dung draw.io ve UML cho nhanh', '2026-03-08 08:10:00'),
  ('room_010', 'DATN_Linh', 'Hoac Mermaid JS, viet code ra diagram luon', '2026-03-08 08:12:00'),
  ('room_010', 'SV_Phuc', 'Chuc moi nguoi do an thanh cong! 💪', '2026-03-08 08:15:00');

-- ============================================================
-- TIN NHAN - TIN TUC CONG NGHE (room_011) - 20 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_011', 'TechNews_Bot', 'Cap nhat tin tuc cong nghe moi nhat!', '2026-03-06 12:00:30'),
  ('room_011', 'TechNews_Bot', 'Apple vua ra mat Vision Pro 2, nhe hon 30% va re hon', '2026-03-06 12:01:00'),
  ('room_011', 'TechFan_01', 'Vision Pro 2 gia bao nhieu?', '2026-03-06 12:10:00'),
  ('room_011', 'TechNews_Bot', 'Du kien 2499 USD, giam 1000 USD so voi ban dau', '2026-03-06 12:12:00'),
  ('room_011', 'AI_Watcher', 'OpenAI vua ra GPT-5, benchmark vuot xa GPT-4', '2026-03-07 08:00:00'),
  ('room_011', 'TechFan_01', 'GPT-5 co gi khac GPT-4?', '2026-03-07 08:05:00'),
  ('room_011', 'AI_Watcher', 'Reasoning tot hon, context window 1M tokens, multimodal cai thien', '2026-03-07 08:07:00'),
  ('room_011', 'OpenSourceFan', 'Llama 4 cua Meta cung sap ra, open source luon', '2026-03-07 08:10:00'),
  ('room_011', 'TechNews_Bot', 'Rust vua vuot Python tren TIOBE index thang 3/2026!', '2026-03-08 09:00:00'),
  ('room_011', 'Rustacean_VN', 'Xung dang! Rust an toan va nhanh', '2026-03-08 09:05:00'),
  ('room_011', 'PythonFan', 'Python van la so 1 cho AI/ML, khong ai thay the duoc', '2026-03-08 09:07:00'),
  ('room_011', 'TechNews_Bot', 'Samsung ra Galaxy S26, chip Snapdragon 8 Gen 4', '2026-03-09 10:00:00'),
  ('room_011', 'PhoneFan', 'Camera co gi moi khong?', '2026-03-09 10:05:00'),
  ('room_011', 'TechNews_Bot', '200MP main + 50MP ultrawide + 50MP tele, AI camera moi', '2026-03-09 10:07:00'),
  ('room_011', 'PhoneFan', 'Gia chac dat lam, Samsung qua roi', '2026-03-09 10:10:00'),
  ('room_011', 'TechNews_Bot', 'GitHub Copilot gio free cho tat ca developer!', '2026-03-10 08:00:00'),
  ('room_011', 'DevThanh', 'That a? Truoc gia 10$/thang ma', '2026-03-10 08:05:00'),
  ('room_011', 'TechNews_Bot', 'Dung, Microsoft chieu khach hang, co gioi han 2000 completions/ngay', '2026-03-10 08:07:00'),
  ('room_011', 'CodingGirl', 'Hay qua! AI ho tro code gio mien phi luon', '2026-03-10 08:10:00'),
  ('room_011', 'TechNews_Bot', 'Follow phong nay de cap nhat tin moi nhat moi ngay!', '2026-03-10 08:12:00');

-- ============================================================
-- TIN NHAN - CO SO DU LIEU (room_013) - 15 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_013', 'DBA_Long', 'Phong thao luan Co So Du Lieu. SQL, NoSQL, thiet ke DB', '2026-03-08 10:00:30'),
  ('room_013', 'SQLStudent', 'Khi nao nen dung NoSQL thay vi SQL?', '2026-03-08 10:30:00'),
  ('room_013', 'DBA_Long', 'NoSQL khi data khong co structure co dinh, can scale ngang, read nhieu', '2026-03-08 10:35:00'),
  ('room_013', 'SQLStudent', 'Vi du cu the?', '2026-03-08 10:37:00'),
  ('room_013', 'DBA_Long', 'Chat app dung MongoDB (flexible schema). Banking dung PostgreSQL (ACID)', '2026-03-08 10:40:00'),
  ('room_013', 'MongoFan', 'MongoDB Atlas free tier du cho project nho', '2026-03-08 14:00:00'),
  ('room_013', 'DBA_Long', 'Dung, hoac dung SQLite cho offline app, nhu QwikChat nay', '2026-03-08 14:05:00'),
  ('room_013', 'IndexExpert', 'Moi nguoi nho tao index cho cac cot thuong query nhe', '2026-03-09 09:00:00'),
  ('room_013', 'SQLStudent', 'Index la gi vay anh?', '2026-03-09 09:05:00'),
  ('room_013', 'IndexExpert', 'Giong nhu muc luc cua sach, giup tim du lieu nhanh hon', '2026-03-09 09:07:00'),
  ('room_013', 'DBA_Long', 'Nhung dung tao qua nhieu index, se cham khi INSERT/UPDATE', '2026-03-09 09:10:00'),
  ('room_013', 'SQLStudent', 'Lam sao biet nen index cot nao?', '2026-03-09 09:12:00'),
  ('room_013', 'IndexExpert', 'Index cac cot trong WHERE, JOIN, ORDER BY', '2026-03-09 09:15:00'),
  ('room_013', 'DBA_Long', 'Dung EXPLAIN ANALYZE de xem query plan truoc khi toi uu', '2026-03-09 09:17:00'),
  ('room_013', 'SQLStudent', 'Cam on 2 anh! Hieu hon nhieu', '2026-03-09 09:20:00');

-- ============================================================
-- TIN NHAN - KHOI NGHIEP STARTUP (room_014) - 15 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_014', 'Founder_Hieu', 'Chao moi nguoi! Phong danh cho nhung ai dam mo khoi nghiep', '2026-03-09 08:00:30'),
  ('room_014', 'StartupDream', 'Minh co y tuong lam app giao do an cho sinh vien, gia re', '2026-03-09 09:00:00'),
  ('room_014', 'Founder_Hieu', 'Y tuong hay! Nhung canh tranh voi Grab, ShopeeFood kho do', '2026-03-09 09:05:00'),
  ('room_014', 'StartupDream', 'Minh target chi sinh vien, phi ship 5k, partner quan an gan truong', '2026-03-09 09:07:00'),
  ('room_014', 'Investor_VN', 'Mo hinh hyperlocal nhu vay co the duoc, can test thi truong', '2026-03-09 09:10:00'),
  ('room_014', 'TechCofounder', 'Minh la developer, dang tim co-founder lam SaaS', '2026-03-09 14:00:00'),
  ('room_014', 'Founder_Hieu', 'SaaS gi vay ban?', '2026-03-09 14:05:00'),
  ('room_014', 'TechCofounder', 'Tool quan ly lich hen cho phong kham nho, thay ho van dung so giay', '2026-03-09 14:07:00'),
  ('room_014', 'Investor_VN', 'Healthcare tech, thi truong lon! Can ban plan chi tiet', '2026-03-09 14:10:00'),
  ('room_014', 'MarketingGuru', 'AI tools cho marketing dang hot lam, ai co y tuong khong?', '2026-03-10 10:00:00'),
  ('room_014', 'Founder_Hieu', 'AI viet content tu dong? Nhieu roi nhung van con co hoi', '2026-03-10 10:05:00'),
  ('room_014', 'MarketingGuru', 'Minh nghi ve AI phan tich doi thu canh tranh, auto report', '2026-03-10 10:07:00'),
  ('room_014', 'TechCofounder', 'Hay do! Web scraping + AI analysis, kha thi ve ky thuat', '2026-03-10 10:10:00'),
  ('room_014', 'StartupDream', 'Moi nguoi co biet chuong trinh ho tro startup nao o VN khong?', '2026-03-10 15:00:00'),
  ('room_014', 'Founder_Hieu', 'SIHUB, Viettel Venture, VIISA, ESP Capital deu co chuong trinh', '2026-03-10 15:05:00');


-- ============================================================
-- TIN NHAN - PHONG NHAC (room_012) - 15 tin nhan
-- ============================================================

INSERT INTO messages (room_id, nickname, content, created_at) VALUES
  ('room_012', 'DJ_Minh', 'Phong Nhac - chia se nhac hay!', '2026-03-07 21:00:30'),
  ('room_012', 'MusicLover', 'Dang nghe "Lac Troi" cua Son Tung, classic', '2026-03-07 21:10:00'),
  ('room_012', 'DJ_Minh', 'Son Tung thi khoi ban, bai nao cung dinh', '2026-03-07 21:12:00'),
  ('room_012', 'IndieFan', 'Ai nghe nhac indie VN khong? Ngot, Chillies, Da LAB', '2026-03-07 22:00:00'),
  ('room_012', 'MusicLover', 'Chillies hay lam! "Nha La Noi" nghe chill', '2026-03-07 22:05:00'),
  ('room_012', 'IndieFan', 'Dung! Va "Qua Khu Co Len" cua Ngot nua', '2026-03-07 22:07:00'),
  ('room_012', 'KPopFan', 'BTS moi comeback! Album moi hay lam', '2026-03-08 15:00:00'),
  ('room_012', 'DJ_Minh', 'K-Pop production level cao that su', '2026-03-08 15:05:00'),
  ('room_012', 'KPopFan', 'NewJeans cung vua ra MV moi, viral khap TikTok', '2026-03-08 15:07:00'),
  ('room_012', 'LoFiChill', 'Ai co playlist lo-fi de code khong?', '2026-03-09 14:00:00'),
  ('room_012', 'DJ_Minh', 'Spotify co "Lo-Fi Beats" rat ngon, hoac YouTube "Lofi Girl"', '2026-03-09 14:05:00'),
  ('room_012', 'LoFiChill', 'Lofi Girl la kinh dien roi, nghe hoai khong chan', '2026-03-09 14:07:00'),
  ('room_012', 'MusicLover', 'Ai biet hoc guitar online o dau khong?', '2026-03-10 09:00:00'),
  ('room_012', 'DJ_Minh', 'YouTube kenh "Justin Guitar" rat tot cho nguoi moi', '2026-03-10 09:05:00'),
  ('room_012', 'MusicLover', 'Thanks! Minh se hoc thu', '2026-03-10 09:07:00');

-- ============================================================
-- KIEM TRA
-- ============================================================

-- Dem phong
-- SELECT COUNT(*) as so_phong FROM rooms;
-- Ket qua mong doi: 15

-- Dem tin nhan
-- SELECT COUNT(*) as so_tin_nhan FROM messages;
-- Ket qua mong doi: ~340

-- Dem tin nhan theo phong
-- SELECT r.name, COUNT(m.id) as so_tin_nhan
-- FROM rooms r LEFT JOIN messages m ON r.id = m.room_id
-- GROUP BY r.id ORDER BY so_tin_nhan DESC;
