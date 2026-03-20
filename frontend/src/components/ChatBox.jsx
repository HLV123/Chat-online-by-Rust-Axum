import { component$, $ } from "@builder.io/qwik";
import { avatarColor, avatarInitial, formatTime } from "../utils/websocket";

export const ChatBox = component$(({
  activeRoomInfo, messages, members, input, connected, reconnecting,
  typingUsers, showEmojiPicker, replyTo, showMembers, currentNickname,
  EMOJIS,
  onInput, onSend, onInsertEmoji, onSetReply, onCancelReply,
  onToggleEmoji, onToggleMembers, onCloseMembers,
}) => {
  return (
    <>
      {/* Header */}
      <div class="h-[60px] bg-[#242526] border-b border-[#3E4042] flex items-center justify-between px-4 shrink-0">
        <div class="flex items-center gap-3 min-w-0">
          <div class="w-10 h-10 rounded-full flex items-center justify-center text-white font-semibold text-lg shrink-0" style={{ background: avatarColor(activeRoomInfo.value?.name || "R") }}>{avatarInitial(activeRoomInfo.value?.name || "R")}</div>
          <div class="min-w-0"><h1 class="font-semibold text-[16px] truncate">{activeRoomInfo.value?.name || "..."}</h1><p class="text-[12px] text-[#B0B3B8]">{connected.value ? (<span class="inline-flex items-center gap-1"><span class="w-2 h-2 bg-[#31A24C] rounded-full" />{members.value.length} online</span>) : reconnecting.value ? <span class="text-[#FFC300]">Dang ket noi lai...</span> : <span class="text-[#FA3E3E]">Mat ket noi</span>}</p></div>
        </div>
        <button onClick$={onToggleMembers} class={`w-9 h-9 rounded-full flex items-center justify-center ${showMembers.value ? "bg-[#0866FF]/20 text-[#0866FF]" : "bg-[#3A3B3C] hover:bg-[#4E4F50]"}`}><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" /><circle cx="9" cy="7" r="4" /><path d="M23 21v-2a4 4 0 0 0-3-3.87" /><path d="M16 3.13a4 4 0 0 1 0 7.75" /></svg></button>
      </div>

      <div class="flex flex-1 overflow-hidden">
        {/* Messages area */}
        <div class="flex-1 flex flex-col min-w-0">
          <div id="chat-messages" class="flex-1 overflow-y-auto px-4 py-4 space-y-1">
            {activeRoomInfo.value && (<div class="text-center mb-6 pt-4"><div class="w-16 h-16 mx-auto rounded-full flex items-center justify-center text-white text-2xl font-bold mb-3" style={{ background: avatarColor(activeRoomInfo.value.name) }}>{avatarInitial(activeRoomInfo.value.name)}</div><h2 class="font-bold text-xl">{activeRoomInfo.value.name}</h2>{activeRoomInfo.value.description && <p class="text-[#B0B3B8] text-[14px] mt-1">{activeRoomInfo.value.description}</p>}<p class="text-[#65676B] text-[13px] mt-2">Tao boi {activeRoomInfo.value.created_by}</p></div>)}

            {messages.value.map((msg, i) => {
              const isMe = msg.nickname === currentNickname.value;
              const isSystem = msg.type === "system";
              const prev = i > 0 ? messages.value[i-1] : null;
              const showAv = !isSystem && !isMe && (!prev || prev.nickname !== msg.nickname || prev.type === "system");
              const k = msg.id ? `m${msg.id}` : `s${i}`;
              if (isSystem) return <div key={k} class="flex justify-center py-2 msg-animate"><span class="text-[#B0B3B8] text-[13px] bg-[#242526] px-3 py-1 rounded-full">{msg.event === "user_joined" && "👋 "}{msg.content}</span></div>;
              const rep = msg.reply_to ? messages.value.find(m => m.id === msg.reply_to) : null;
              return (
                <div key={k} class={`flex msg-animate group ${isMe ? "justify-end" : "justify-start"} ${showAv ? "mt-3" : "mt-0.5"}`}>
                  {!isMe && <div class="w-8 mr-2 shrink-0 self-end">{showAv ? <div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-semibold" style={{ background: avatarColor(msg.nickname) }} title={msg.nickname}>{avatarInitial(msg.nickname)}</div> : <div class="w-8" />}</div>}
                  <div class={`max-w-[65%] min-w-[60px] ${isMe ? "items-end" : "items-start"}`}>
                    {!isMe && showAv && <p class="text-[13px] text-[#B0B3B8] mb-1 ml-1 font-medium">{msg.nickname}</p>}
                    {rep && <div class={`text-[12px] mb-1 px-3 py-1 rounded-lg border-l-2 border-[#0866FF] ${isMe ? "bg-[#1A3A5C] text-[#7CB7FF] ml-auto" : "bg-[#3A3B3C] text-[#B0B3B8]"}`} style={{ maxWidth: "90%" }}><span class="font-semibold">{rep.nickname}:</span> {rep.content.length > 60 ? rep.content.slice(0,60)+"..." : rep.content}</div>}
                    <div class="relative group/msg">
                      <div class={`px-3 py-2 text-[15px] leading-relaxed break-words ${isMe ? "bg-[#0866FF] text-white rounded-[18px] rounded-br-[4px]" : "bg-[#3A3B3C] text-[#E4E6EB] rounded-[18px] rounded-bl-[4px]"}`}>{msg.content}</div>
                      <div class={`absolute top-1/2 -translate-y-1/2 opacity-0 group-hover/msg:opacity-100 ${isMe ? "right-full mr-1" : "left-full ml-1"}`}><button onClick$={() => onSetReply(msg)} class="w-7 h-7 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center text-[#B0B3B8] hover:text-white"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 17 4 12 9 7" /><path d="M20 18v-2a4 4 0 0 0-4-4H4" /></svg></button></div>
                      <div class={`absolute bottom-full mb-1 text-[11px] text-[#B0B3B8] opacity-0 group-hover/msg:opacity-100 whitespace-nowrap pointer-events-none ${isMe ? "right-0" : "left-0"}`}>{formatTime(msg.created_at)}</div>
                    </div>
                  </div>
                </div>
              );
            })}
            {typingUsers.value.length > 0 && <div class="flex items-center gap-2 mt-2 msg-animate"><div class="w-8 mr-2 shrink-0"><div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-xs font-semibold" style={{ background: avatarColor(typingUsers.value[0]) }}>{avatarInitial(typingUsers.value[0])}</div></div><div class="bg-[#3A3B3C] rounded-[18px] px-4 py-3 flex items-center gap-1"><div class="w-2 h-2 bg-[#B0B3B8] rounded-full typing-dot" /><div class="w-2 h-2 bg-[#B0B3B8] rounded-full typing-dot" /><div class="w-2 h-2 bg-[#B0B3B8] rounded-full typing-dot" /></div></div>}
          </div>

          {/* Reply bar */}
          {replyTo.value && <div class="px-4 py-2 bg-[#242526] border-t border-[#3E4042] flex items-center gap-3"><div class="w-1 h-8 bg-[#0866FF] rounded-full shrink-0" /><div class="flex-1 min-w-0"><p class="text-[12px] text-[#0866FF] font-semibold">Tra loi {replyTo.value.nickname}</p><p class="text-[13px] text-[#B0B3B8] truncate">{replyTo.value.content}</p></div><button onClick$={onCancelReply} class="w-7 h-7 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center shrink-0"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12" /></svg></button></div>}

          {/* Input */}
          <div class="px-4 py-3 bg-[#242526] border-t border-[#3E4042] shrink-0"><div class="flex items-end gap-2">
            <div class="relative" id="emoji-picker-container"><button onClick$={onToggleEmoji} class={`w-9 h-9 rounded-full flex items-center justify-center ${showEmojiPicker.value ? "bg-[#0866FF]/20 text-[#0866FF]" : "text-[#0866FF] hover:bg-[#3A3B3C]"}`}><svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><circle cx="12" cy="12" r="10" /><path d="M8 14s1.5 2 4 2 4-2 4-2" /><line x1="9" y1="9" x2="9.01" y2="9" stroke-width="3" stroke-linecap="round" /><line x1="15" y1="9" x2="15.01" y2="9" stroke-width="3" stroke-linecap="round" /></svg></button>{showEmojiPicker.value && <div class="absolute bottom-12 left-0 bg-[#242526] border border-[#3E4042] rounded-xl shadow-xl p-3 w-[280px] z-50"><div class="grid grid-cols-6 gap-1">{EMOJIS.map(em => <button key={em} onClick$={() => onInsertEmoji(em)} class="w-10 h-10 text-xl hover:bg-[#3A3B3C] rounded-lg flex items-center justify-center">{em}</button>)}</div></div>}</div>
            <div class="flex-1"><input id="msg-input" type="text" placeholder={connected.value ? "Aa" : "Ket noi..."} class="w-full bg-[#3A3B3C] text-[#E4E6EB] placeholder-[#B0B3B8] rounded-full py-2.5 px-4 text-[15px] outline-none focus:ring-1 focus:ring-[#0866FF]/50" value={input.value} onInput$={onInput} disabled={!connected.value} maxLength={2000} /></div>
            <button onClick$={onSend} disabled={!connected.value || !input.value.trim()} class="w-9 h-9 rounded-full flex items-center justify-center text-[#0866FF] hover:bg-[#3A3B3C] disabled:opacity-30 shrink-0"><svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z" /></svg></button>
          </div></div>
        </div>

        {/* Members panel */}
        {showMembers.value && <div class="w-[260px] bg-[#242526] border-l border-[#3E4042] flex flex-col shrink-0">
          <div class="h-[52px] flex items-center justify-between px-4 border-b border-[#3E4042]"><h3 class="font-semibold text-[15px]">Thanh vien</h3><button onClick$={onCloseMembers} class="w-7 h-7 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12" /></svg></button></div>
          <div class="flex-1 overflow-y-auto p-2"><p class="text-[12px] text-[#B0B3B8] font-semibold px-2 py-2 uppercase">Online — {members.value.length}</p>{members.value.map(m => <div key={m} class="flex items-center gap-3 px-2 py-2 rounded-lg hover:bg-[#3A3B3C]"><div class="relative shrink-0"><div class="w-8 h-8 rounded-full flex items-center justify-center text-white text-sm font-semibold" style={{ background: avatarColor(m) }}>{avatarInitial(m)}</div><div class="absolute -bottom-0.5 -right-0.5 w-3 h-3 bg-[#31A24C] border-2 border-[#242526] rounded-full" /></div><p class="text-[13px] font-medium truncate">{m}{m === currentNickname.value && <span class="text-[11px] text-[#B0B3B8] ml-1">(ban)</span>}</p></div>)}</div>
        </div>}
      </div>
    </>
  );
});
