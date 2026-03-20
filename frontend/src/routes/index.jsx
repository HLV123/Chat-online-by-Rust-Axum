import { component$, useSignal, useVisibleTask$, useStore, $, useOnDocument, useComputed$ } from "@builder.io/qwik";
import { randomNickname } from "../utils/websocket";
import { Sidebar } from "../components/Sidebar";
import { ChatBox } from "../components/ChatBox";
import { CreateRoomModal, DeleteRoomModal, NickAuthModal } from "../components/Modals";

export default component$(() => {
  // ─── State ───
  const rooms = useSignal([]);
  const nickname = useSignal("");
  const nickPassword = useSignal("");    
  const searchQuery = useSignal("");
  const loading = useSignal(true);
  const loadError = useSignal(null);
  const showCreateModal = useSignal(false);
  const newRoomName = useSignal("");
  const newRoomDesc = useSignal("");
  const newRoomPassword = useSignal("");

  const showNickModal = useSignal(false);
  const pendingRoomId = useSignal(null);
  const nickModalError = useSignal("");
  const openRoomTrigger = useSignal(0);    

  const showDeleteModal = useSignal(false);
  const deleteRoomId = useSignal(null);
  const deleteRoomName = useSignal("");
  const deletePassword = useSignal("");
  const deleteError = useSignal("");
  const deleteLoading = useSignal(false);

  const activeRoomId = useSignal(null);
  const activeRoomInfo = useSignal(null);
  const messages = useSignal([]);
  const members = useSignal([]);
  const input = useSignal("");
  const connected = useSignal(false);
  const reconnecting = useSignal(false);
  const typingUsers = useSignal([]);
  const showEmojiPicker = useSignal(false);
  const replyTo = useSignal(null);
  const showMembers = useSignal(false);
  const currentNickname = useSignal("");

  const unread = useStore({});
  const lastSeen = useStore({});
  const drafts = useStore({});
  const roomActivity = useStore({});

  const apiUrl = import.meta.env.VITE_API_URL || "";
  const EMOJIS = ["😀","😂","😍","🥰","😎","🤔","👍","👎","❤️","🔥","🎉","😭","😡","🤣","💯","✅","👀","🙏","💪","🤝","😅","🥲","😢","😤","🫡","🫠","💀","👻","🎊","⭐"];

  const scrollToBottom = $(() => { setTimeout(() => { const el = document.getElementById("chat-messages"); if (el) el.scrollTop = el.scrollHeight; }, 60); });
  const saveNickname = $(() => { if (nickname.value.trim()) localStorage.setItem("qwikchat_nickname", nickname.value.trim()); });

  // ─── Load rooms ───
  const loadRooms = $(async () => {
    try {
      const res = await fetch(`${apiUrl}/api/rooms`);
      if (res.ok) {
        const data = await res.json(); rooms.value = data; loadError.value = null;
        for (const r of data) {
          if (!roomActivity[r.id]) roomActivity[r.id] = r.created_at || "2000-01-01";
          if (lastSeen[r.id] === undefined) { try { const m = await fetch(`${apiUrl}/api/rooms/${r.id}/messages?limit=1`); if (m.ok) { const msgs = await m.json(); lastSeen[r.id] = msgs.length > 0 ? msgs[msgs.length-1].id : 0; } } catch { lastSeen[r.id] = 0; } }
        }
      } else { loadError.value = "Khong the tai phong"; }
    } catch { loadError.value = "Khong the ket noi server"; }
    finally { loading.value = false; }
  });

  useVisibleTask$(() => {
    const s1 = localStorage.getItem("qwikchat_nickname"); if (s1) nickname.value = s1;
    const s2 = sessionStorage.getItem("qwikchat_nickpw"); if (s2) nickPassword.value = s2; // #3: sessionStorage
    const s3 = localStorage.getItem("qwikchat_drafts"); if (s3) { try { Object.assign(drafts, JSON.parse(s3)); } catch {} }
    loadRooms();
    const iv = setInterval(() => loadRooms(), 8000);
    return () => clearInterval(iv);
  });

  const createRoom = $(async () => {
    if (!newRoomName.value.trim() || !newRoomPassword.value.trim()) return;
    const nick = nickname.value.trim() || randomNickname(); nickname.value = nick; saveNickname();
    try {
      const res = await fetch(`${apiUrl}/api/rooms`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ name: newRoomName.value.trim(), description: newRoomDesc.value.trim() || null, created_by: nick, room_password: newRoomPassword.value.trim() }) });
      const data = await res.json();
      if (res.ok) { newRoomName.value = ""; newRoomDesc.value = ""; newRoomPassword.value = ""; showCreateModal.value = false; await loadRooms(); if (nickPassword.value.trim()) { pendingRoomId.value = data.id; openRoomTrigger.value++; } }
      else alert(data.error || "Loi");
    } catch { alert("Loi ket noi!"); }
  });

  const confirmDeleteRoom = $(async () => {
    if (!deletePassword.value.trim()) { deleteError.value = "Nhap mat khau"; return; }
    deleteLoading.value = true; deleteError.value = "";
    try {
      const res = await fetch(`${apiUrl}/api/rooms/${deleteRoomId.value}/delete`, { method: "POST", headers: { "Content-Type": "application/json" }, body: JSON.stringify({ room_password: deletePassword.value.trim() }) });
      const data = await res.json();
      if (res.ok) { showDeleteModal.value = false; if (activeRoomId.value === deleteRoomId.value) { if (window.__qc_ws) { window.__qc_ws.close(); window.__qc_ws = null; } activeRoomId.value = null; activeRoomInfo.value = null; messages.value = []; } await loadRooms(); }
      else deleteError.value = data.error || "Loi";
    } catch { deleteError.value = "Loi ket noi"; } finally { deleteLoading.value = false; }
  });

  const onClickRoom = $((roomId) => {
    if (!nickname.value.trim()) { alert("Nhap nickname truoc"); return; }
    if (!nickPassword.value.trim()) { pendingRoomId.value = roomId; nickModalError.value = ""; showNickModal.value = true; return; }
    pendingRoomId.value = roomId;
    openRoomTrigger.value++; 
  });

  const confirmNickPassword = $(() => {
    const pw = nickPassword.value.trim();
    if (!pw || pw.length < 4) { nickModalError.value = "Mat khau toi thieu 4 ky tu"; return; } // #6
    sessionStorage.setItem("qwikchat_nickpw", pw); 
    showNickModal.value = false;
    openRoomTrigger.value++;  
  });

  useVisibleTask$(({ track }) => {
    const trigger = track(() => openRoomTrigger.value);
    if (trigger === 0) return;

    const roomIdToOpen = pendingRoomId.value;
    const nick = nickname.value.trim();
    const pw = nickPassword.value.trim();
    if (!roomIdToOpen || !nick || !pw) return;

    if (activeRoomId.value && input.value.trim()) { drafts[activeRoomId.value] = input.value; localStorage.setItem("qwikchat_drafts", JSON.stringify(drafts)); }

    if (window.__qc_retry) { clearTimeout(window.__qc_retry); window.__qc_retry = null; }
    if (window.__qc_hb) { clearInterval(window.__qc_hb); window.__qc_hb = null; }
    if (window.__qc_ws) { window.__qc_ws.close(); window.__qc_ws = null; }

    activeRoomId.value = roomIdToOpen;
    messages.value = []; members.value = []; connected.value = false; reconnecting.value = false;
    typingUsers.value = []; replyTo.value = null; showEmojiPicker.value = false; showMembers.value = false;
    input.value = drafts[roomIdToOpen] || ""; delete unread[roomIdToOpen];
    currentNickname.value = nick; localStorage.setItem("qwikchat_nickname", nick);

    (async () => {
      try { const r = await fetch(`${apiUrl}/api/rooms/${roomIdToOpen}`); if (r.ok) activeRoomInfo.value = await r.json(); } catch {}
      try { const r = await fetch(`${apiUrl}/api/rooms/${roomIdToOpen}/messages`); if (r.ok) { messages.value = await r.json(); scrollToBottom(); } } catch {}
      if (messages.value.length > 0) lastSeen[roomIdToOpen] = messages.value[messages.value.length-1].id;

      let retryCount = 0;
      function connectWS() {

        const wsBase = apiUrl
          ? apiUrl.replace("http://", "ws://").replace("https://", "wss://")
          : (window.location.protocol === "https:" ? "wss://" : "ws://") + window.location.host;
        const socket = new WebSocket(`${wsBase}/ws/${roomIdToOpen}?nickname=${encodeURIComponent(nick)}`);

        socket.onopen = () => {
    
          socket.send(JSON.stringify({ type: "auth", password: pw }));
        };

        socket.onmessage = (event) => {
          try {
            const data = JSON.parse(event.data);
            switch (data.type) {
              case "auth_ok":
                connected.value = true; reconnecting.value = false; retryCount = 0;
                if (window.__qc_hb) clearInterval(window.__qc_hb);
                window.__qc_hb = setInterval(() => { if (socket.readyState === WebSocket.OPEN) socket.send(JSON.stringify({ type: "heartbeat" })); }, 30000);
                break;
              case "auth_fail": case "error":
                nickPassword.value = ""; sessionStorage.removeItem("qwikchat_nickpw");
                nickModalError.value = data.content || "Sai mat khau"; pendingRoomId.value = roomIdToOpen; showNickModal.value = true;
                socket.close(); break;
              case "chat_message":
                if (activeRoomId.value === roomIdToOpen) { messages.value = [...messages.value, data]; scrollToBottom(); lastSeen[roomIdToOpen] = data.id; }
                roomActivity[roomIdToOpen] = data.created_at || new Date().toISOString(); break;
              case "system":
                if (activeRoomId.value === roomIdToOpen) { messages.value = [...messages.value, { type: "system", id: data.id, content: data.content, event: data.event, created_at: new Date().toISOString() }]; scrollToBottom(); } break;
              case "members_update":
                if (activeRoomId.value === roomIdToOpen) members.value = data.members || []; break;
              case "typing": {
                if (activeRoomId.value !== roomIdToOpen) break;
                const who = data.nickname; if (who === nick) break;
                if (data.is_typing) { if (!typingUsers.value.includes(who)) typingUsers.value = [...typingUsers.value, who]; }
                else typingUsers.value = typingUsers.value.filter(u => u !== who); break;
              }
            }
          } catch {}
        };

        socket.onclose = () => {
          connected.value = false;
          if (retryCount < 5 && activeRoomId.value === roomIdToOpen) { reconnecting.value = true; retryCount++; window.__qc_retry = setTimeout(connectWS, Math.min(3000 * Math.pow(2, retryCount), 30000)); }
        };
        socket.onerror = () => socket.close();
        window.__qc_ws = socket;
      }
      connectWS();
      setTimeout(() => document.getElementById("msg-input")?.focus(), 200);
    })();

    return () => {
      if (window.__qc_retry) { clearTimeout(window.__qc_retry); window.__qc_retry = null; }
      if (window.__qc_hb) { clearInterval(window.__qc_hb); window.__qc_hb = null; }
      if (window.__qc_ws) { window.__qc_ws.close(); window.__qc_ws = null; }
    };
  });

  const sendMessage = $(() => {
    const s = window.__qc_ws; if (!s || s.readyState !== WebSocket.OPEN) return;
    const text = input.value.trim(); if (!text) return;
    s.send(JSON.stringify({ type: "chat_message", content: text, reply_to: replyTo.value?.id || null }));
    input.value = ""; replyTo.value = null; showEmojiPicker.value = false;
    if (activeRoomId.value) { delete drafts[activeRoomId.value]; localStorage.setItem("qwikchat_drafts", JSON.stringify(drafts)); }
    s.send(JSON.stringify({ type: "typing", is_typing: false }));
  });

  const handleInput = $((e) => {
    input.value = e.target.value;
    if (activeRoomId.value) { if (e.target.value.trim()) drafts[activeRoomId.value] = e.target.value; else delete drafts[activeRoomId.value]; localStorage.setItem("qwikchat_drafts", JSON.stringify(drafts)); }
    const s = window.__qc_ws;
    if (s && s.readyState === WebSocket.OPEN) { s.send(JSON.stringify({ type: "typing", is_typing: true })); if (window.__qc_tt) clearTimeout(window.__qc_tt); window.__qc_tt = setTimeout(() => { const ws = window.__qc_ws; if (ws && ws.readyState === WebSocket.OPEN) ws.send(JSON.stringify({ type: "typing", is_typing: false })); }, 2000); }
  });

  useOnDocument("keydown", $((e) => { if (e.key === "Enter" && !e.shiftKey && document.activeElement === document.getElementById("msg-input")) { e.preventDefault(); sendMessage(); } }));
  useOnDocument("click", $((e) => { if (showEmojiPicker.value) { const p = document.getElementById("emoji-picker-container"); if (p && !p.contains(e.target)) showEmojiPicker.value = false; } }));

  useVisibleTask$(({ cleanup }) => {
    const iv = setInterval(async () => {
      if (document.visibilityState !== "visible" || !rooms.value?.length) return;
      for (const room of rooms.value) {
        if (room.id === activeRoomId.value) continue;
        try {
          const res = await fetch(`${apiUrl}/api/rooms/${room.id}/unread-count?after=${lastSeen[room.id] || 0}`);
          if (res.ok) { const d = await res.json(); if (d.count > 0 && d.latest) { unread[room.id] = { count: d.count, lastMsg: d.latest.content, lastNickname: d.latest.nickname, lastTime: d.latest.created_at }; roomActivity[room.id] = d.latest.created_at; } else if (d.count === 0 && unread[room.id]) delete unread[room.id]; }
        } catch {}
      }
    }, 3000);
    cleanup(() => clearInterval(iv));
  });

  const sortedRooms = useComputed$(() => {
    let f = rooms.value;
    if (searchQuery.value.trim()) { const q = searchQuery.value.toLowerCase(); f = f.filter(r => r.name.toLowerCase().includes(q) || (r.description && r.description.toLowerCase().includes(q))); }
    return [...f].sort((a, b) => (roomActivity[b.id] || b.created_at || "").localeCompare(roomActivity[a.id] || a.created_at || ""));
  });

  return (
    <div class="flex h-screen bg-[#18191A] text-[#E4E6EB] overflow-hidden">
      <Sidebar
        rooms={rooms} searchQuery={searchQuery} nickname={nickname} nickPassword={nickPassword}
        loading={loading} loadError={loadError} sortedRooms={sortedRooms} unread={unread} activeRoomId={activeRoomId}
        onSearch={$((e) => (searchQuery.value = e.target.value))}
        onNickChange={$((e) => { nickname.value = e.target.value; nickPassword.value = ""; sessionStorage.removeItem("qwikchat_nickpw"); })}
        onNickBlur={saveNickname}
        onClickRoom={onClickRoom}
        onDeleteRoom={$((id, name) => { deleteRoomId.value = id; deleteRoomName.value = name; deletePassword.value = ""; deleteError.value = ""; deleteLoading.value = false; showDeleteModal.value = true; })}
        onCreateRoom={$(() => (showCreateModal.value = true))}
        onRetry={$(() => { loading.value = true; loadError.value = null; loadRooms(); })}
      />

      <div class="flex-1 flex flex-col min-w-0">
        {!activeRoomId.value ? (
          <div class="flex-1 flex flex-col items-center justify-center"><div class="text-center max-w-md px-6">
            <div class="w-24 h-24 mx-auto mb-6 rounded-full flex items-center justify-center" style="background: linear-gradient(135deg, #00C6FF, #0078FF);"><svg width="48" height="48" viewBox="0 0 24 24" fill="white"><path d="M12 2C6.477 2 2 6.145 2 11.243c0 2.936 1.444 5.539 3.7 7.236V22l3.405-1.869A11.04 11.04 0 0 0 12 20.485c5.523 0 10-4.144 10-9.242S17.523 2 12 2zm1.07 12.457-2.54-2.71-4.96 2.71 5.45-5.783 2.602 2.71 4.895-2.71-5.446 5.783z" /></svg></div>
            <h2 class="text-xl font-bold mb-2">QwikChat</h2>
            <p class="text-[#B0B3B8] text-[15px] mb-8">Chat an danh. Chon phong hoac tao moi.</p>
            <button onClick$={() => (showCreateModal.value = true)} class="inline-flex items-center gap-2 bg-[#0866FF] hover:bg-[#0756d6] text-white rounded-full px-6 py-3 font-semibold"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14" /></svg>Tao phong moi</button>
          </div></div>
        ) : (
          <ChatBox
            activeRoomInfo={activeRoomInfo} messages={messages} members={members} input={input}
            connected={connected} reconnecting={reconnecting} typingUsers={typingUsers}
            showEmojiPicker={showEmojiPicker} replyTo={replyTo} showMembers={showMembers}
            currentNickname={currentNickname} EMOJIS={EMOJIS}
            onInput={handleInput} onSend={sendMessage}
            onInsertEmoji={$((em) => { input.value += em; showEmojiPicker.value = false; setTimeout(() => document.getElementById("msg-input")?.focus(), 50); })}
            onSetReply={$((msg) => { replyTo.value = { id: msg.id, nickname: msg.nickname, content: msg.content }; setTimeout(() => document.getElementById("msg-input")?.focus(), 50); })}
            onCancelReply={$(() => (replyTo.value = null))}
            onToggleEmoji={$(() => (showEmojiPicker.value = !showEmojiPicker.value))}
            onToggleMembers={$(() => (showMembers.value = !showMembers.value))}
            onCloseMembers={$(() => (showMembers.value = false))}
          />
        )}
      </div>

      <CreateRoomModal show={showCreateModal} name={newRoomName} desc={newRoomDesc} password={newRoomPassword}
        onClose={$(() => (showCreateModal.value = false))} onChangeName={$((e) => (newRoomName.value = e.target.value))}
        onChangeDesc={$((e) => (newRoomDesc.value = e.target.value))} onChangePw={$((e) => (newRoomPassword.value = e.target.value))}
        onCreate={createRoom} />
      <DeleteRoomModal show={showDeleteModal} roomName={deleteRoomName} password={deletePassword} error={deleteError} isLoading={deleteLoading}
        onClose={$(() => (showDeleteModal.value = false))} onChangePw={$((e) => { deletePassword.value = e.target.value; deleteError.value = ""; })}
        onConfirm={confirmDeleteRoom} />
      <NickAuthModal show={showNickModal} nickname={nickname} password={nickPassword} error={nickModalError}
        onClose={$(() => (showNickModal.value = false))} onChangePw={$((e) => { nickPassword.value = e.target.value; nickModalError.value = ""; })}
        onConfirm={confirmNickPassword} />
    </div>
  );
});
