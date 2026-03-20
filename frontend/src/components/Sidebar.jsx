import { component$ } from "@builder.io/qwik";
import { avatarColor, avatarInitial, formatTime } from "../utils/websocket";

export const Sidebar = component$(({
  rooms, searchQuery, nickname, nickPassword, loading, loadError,
  sortedRooms, unread, activeRoomId,
  onSearch, onNickChange, onNickBlur, onClickRoom, onDeleteRoom, onCreateRoom, onRetry,
}) => {
  return (
    <div class="w-[360px] flex flex-col border-r border-[#3E4042] bg-[#242526] shrink-0">
      <div class="px-4 pt-5 pb-2 shrink-0">
        <div class="flex items-center justify-between mb-4">
          <h1 class="text-2xl font-bold">Chat</h1>
          <button onClick$={onCreateRoom} class="w-9 h-9 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center" aria-label="Tao phong"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 5v14M5 12h14" /></svg></button>
        </div>
        <div class="relative mb-3"><svg class="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-[#B0B3B8]" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8" /><path d="m21 21-4.35-4.35" /></svg><input type="text" placeholder="Tim kiem..." class="w-full bg-[#3A3B3C] text-[#E4E6EB] placeholder-[#B0B3B8] rounded-full py-2 pl-10 pr-4 text-[15px] outline-none focus:ring-1 focus:ring-[#0866FF]" value={searchQuery.value} onInput$={onSearch} /></div>
        <div class="flex items-center gap-2 bg-[#3A3B3C] rounded-lg px-3 py-2 mb-1">
          <div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-semibold shrink-0" style={{ background: avatarColor(nickname.value || "?") }}>{avatarInitial(nickname.value || "?")}</div>
          <input type="text" placeholder="Nickname..." class="flex-1 bg-transparent text-[14px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none" value={nickname.value} onInput$={onNickChange} onBlur$={onNickBlur} />
          {nickPassword.value ? <span class="text-[10px] text-[#31A24C]">🔒</span> : <span class="text-[10px] text-[#B0B3B8]">🔓</span>}
        </div>
      </div>
      <div class="flex-1 overflow-y-auto px-2 py-1">
        {loading.value ? (
          <div class="flex flex-col gap-3 px-2 pt-3">{[1,2,3,4,5].map(i => (<div key={i} class="flex items-center gap-3 animate-pulse"><div class="w-12 h-12 rounded-full bg-[#3A3B3C]" /><div class="flex-1"><div class="h-4 bg-[#3A3B3C] rounded w-3/4 mb-2" /><div class="h-3 bg-[#3A3B3C] rounded w-1/2" /></div></div>))}</div>
        ) : loadError.value ? (
          <div class="text-center py-16 px-4"><p class="text-[15px] mb-1">{loadError.value}</p><button onClick$={onRetry} class="mt-3 px-4 py-2 rounded-md bg-[#0866FF] text-white font-semibold">Thu lai</button></div>
        ) : sortedRooms.value.length === 0 ? (
          <div class="text-center py-16 px-4"><p class="text-[#B0B3B8]">Chua co phong nao</p></div>
        ) : sortedRooms.value.map(room => {
          const isActive = activeRoomId.value === room.id;
          const u = unread[room.id];
          const hasUnread = u?.count > 0;
          return (
            <div key={room.id} class="relative group/room">
              <button onClick$={() => onClickRoom(room.id)} class={`w-full flex items-center gap-3 px-3 py-3 rounded-lg text-left transition-colors ${isActive ? "bg-[#0866FF]/15" : hasUnread ? "bg-[#3A3B3C]/50 hover:bg-[#3A3B3C]" : "hover:bg-[#3A3B3C]"}`}>
                <div class="relative shrink-0"><div class="w-12 h-12 rounded-full flex items-center justify-center text-white text-lg font-semibold" style={{ background: avatarColor(room.name) }}>{avatarInitial(room.name)}</div>{room.member_count > 0 && <div class="absolute -bottom-0.5 -right-0.5 w-4 h-4 bg-[#31A24C] border-2 border-[#242526] rounded-full" />}</div>
                <div class="flex-1 min-w-0">
                  <div class="flex items-center justify-between"><span class={`text-[15px] truncate ${hasUnread ? "font-bold text-white" : "font-semibold"}`}>{room.name}</span>{hasUnread && u.lastTime && <span class="text-[11px] text-[#0866FF] font-semibold shrink-0 ml-2">{formatTime(u.lastTime)}</span>}</div>
                  <div class="flex items-center justify-between"><span class={`text-[13px] truncate ${hasUnread ? "text-[#E4E6EB] font-semibold" : "text-[#B0B3B8]"}`}>{hasUnread ? `${u.lastNickname}: ${u.lastMsg}` : (room.description || `Tao boi ${room.created_by}`)}</span>{hasUnread && <span class="ml-2 shrink-0 w-5 h-5 rounded-full bg-[#0866FF] text-white text-[11px] font-bold flex items-center justify-center">{u.count > 9 ? "9+" : u.count}</span>}{!hasUnread && room.member_count > 0 && <span class="text-[12px] text-[#B0B3B8] shrink-0 ml-2 inline-flex items-center gap-1"><span class="w-2 h-2 bg-[#31A24C] rounded-full" />{room.member_count}</span>}</div>
                </div>
              </button>
              <button onClick$={(e) => { e.stopPropagation(); onDeleteRoom(room.id, room.name); }} class="absolute top-2 right-2 w-7 h-7 rounded-full bg-[#3A3B3C] hover:bg-[#FA3E3E] flex items-center justify-center opacity-0 group-hover/room:opacity-100 transition-all z-10"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="3 6 5 6 21 6" /><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" /></svg></button>
            </div>
          );
        })}
      </div>
    </div>
  );
});
