import { component$ } from "@builder.io/qwik";
import { avatarColor, avatarInitial } from "../utils/websocket";

export const CreateRoomModal = component$(({ show, name, desc, password, onClose, onChangeName, onChangeDesc, onChangePw, onCreate }) => {
  if (!show.value) return null;
  return (
    <div class="fixed inset-0 z-50 flex items-center justify-center" role="dialog" onClick$={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div class="absolute inset-0 bg-black/60" />
      <div class="relative bg-[#242526] rounded-xl shadow-2xl w-[440px] max-w-[90vw]">
        <div class="flex items-center justify-between px-4 py-3 border-b border-[#3E4042]"><h3 class="text-lg font-bold">Tao phong moi</h3><button onClick$={onClose} class="w-8 h-8 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12" /></svg></button></div>
        <div class="p-4 space-y-4">
          <div><label class="block text-[13px] text-[#B0B3B8] mb-1.5">Ten phong *</label><input type="text" placeholder="VD: Nhom K20..." class="w-full bg-[#3A3B3C] border border-[#3E4042] rounded-lg px-3 py-2.5 text-[15px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none focus:border-[#0866FF]" value={name.value} onInput$={onChangeName} /></div>
          <div><label class="block text-[13px] text-[#B0B3B8] mb-1.5">Mo ta</label><input type="text" placeholder="..." class="w-full bg-[#3A3B3C] border border-[#3E4042] rounded-lg px-3 py-2.5 text-[15px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none focus:border-[#0866FF]" value={desc.value} onInput$={onChangeDesc} /></div>
          <div><label class="block text-[13px] text-[#B0B3B8] mb-1.5">Mat khau phong *</label><input type="password" placeholder="De xoa phong sau..." class="w-full bg-[#3A3B3C] border border-[#3E4042] rounded-lg px-3 py-2.5 text-[15px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none focus:border-[#0866FF]" value={password.value} onInput$={onChangePw} /></div>
        </div>
        <div class="flex justify-end gap-2 px-4 py-3 border-t border-[#3E4042]"><button onClick$={onClose} class="px-4 py-2 rounded-md text-[#B0B3B8] hover:bg-[#3A3B3C] font-semibold">Huy</button><button onClick$={onCreate} disabled={!name.value.trim() || !password.value.trim()} class="px-5 py-2 rounded-md bg-[#0866FF] hover:bg-[#0756d6] text-white font-semibold disabled:opacity-40">Tao</button></div>
      </div>
    </div>
  );
});

export const DeleteRoomModal = component$(({ show, roomName, password, error, isLoading, onClose, onChangePw, onConfirm }) => {
  if (!show.value) return null;
  return (
    <div class="fixed inset-0 z-50 flex items-center justify-center" role="dialog" onClick$={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div class="absolute inset-0 bg-black/60" />
      <div class="relative bg-[#242526] rounded-xl shadow-2xl w-[420px] max-w-[90vw]">
        <div class="flex items-center justify-between px-4 py-3 border-b border-[#3E4042]"><h3 class="text-lg font-bold text-[#FA3E3E]">Xoa phong</h3><button onClick$={onClose} class="w-8 h-8 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12" /></svg></button></div>
        <div class="p-4 space-y-4"><p class="text-[14px] text-[#B0B3B8]">Xoa <span class="text-white font-semibold">"{roomName.value}"</span>?</p><div><input type="password" placeholder="Mat khau phong..." class="w-full bg-[#3A3B3C] border border-[#3E4042] rounded-lg px-3 py-2.5 text-[15px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none focus:border-[#FA3E3E]" value={password.value} onInput$={onChangePw} onKeyUp$={(e) => { if (e.key === "Enter") onConfirm(); }} />{error.value && <p class="text-[12px] text-[#FA3E3E] mt-1">{error.value}</p>}</div></div>
        <div class="flex justify-end gap-2 px-4 py-3 border-t border-[#3E4042]"><button onClick$={onClose} class="px-4 py-2 rounded-md text-[#B0B3B8] hover:bg-[#3A3B3C] font-semibold">Huy</button><button onClick$={onConfirm} disabled={!password.value.trim() || isLoading.value} class="px-5 py-2 rounded-md bg-[#FA3E3E] hover:bg-[#d63333] text-white font-semibold disabled:opacity-40">{isLoading.value ? "..." : "Xoa"}</button></div>
      </div>
    </div>
  );
});

export const NickAuthModal = component$(({ show, nickname, password, error, onClose, onChangePw, onConfirm }) => {
  if (!show.value) return null;
  return (
    <div class="fixed inset-0 z-50 flex items-center justify-center" role="dialog" onClick$={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div class="absolute inset-0 bg-black/60" />
      <div class="relative bg-[#242526] rounded-xl shadow-2xl w-[400px] max-w-[90vw]">
        <div class="flex items-center justify-between px-4 py-3 border-b border-[#3E4042]"><h3 class="text-lg font-bold">Xac thuc nickname</h3><button onClick$={onClose} class="w-8 h-8 rounded-full bg-[#3A3B3C] hover:bg-[#4E4F50] flex items-center justify-center"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 6 6 18M6 6l12 12" /></svg></button></div>
        <div class="p-4 space-y-4">
          <div class="flex items-center gap-3"><div class="w-12 h-12 rounded-full flex items-center justify-center text-white text-xl font-bold shrink-0" style={{ background: avatarColor(nickname.value) }}>{avatarInitial(nickname.value)}</div><div><p class="font-semibold">{nickname.value}</p><p class="text-[12px] text-[#B0B3B8]">Nhap mat khau de su dung nickname</p></div></div>
          <div><input type="password" placeholder="Lan dau = dat moi, lan sau = nhap lai" class="w-full bg-[#3A3B3C] border border-[#3E4042] rounded-lg px-3 py-2.5 text-[15px] text-[#E4E6EB] placeholder-[#B0B3B8] outline-none focus:border-[#0866FF]" value={password.value} onInput$={onChangePw} onKeyUp$={(e) => { if (e.key === "Enter") onConfirm(); }} />{error.value && <p class="text-[12px] text-[#FA3E3E] mt-1">{error.value}</p>}<p class="text-[11px] text-[#65676B] mt-1">Mat khau toi thieu 4 ky tu</p></div>
        </div>
        <div class="flex justify-end gap-2 px-4 py-3 border-t border-[#3E4042]"><button onClick$={onClose} class="px-4 py-2 rounded-md text-[#B0B3B8] hover:bg-[#3A3B3C] font-semibold">Huy</button><button onClick$={onConfirm} disabled={!password.value.trim() || password.value.trim().length < 4} class="px-5 py-2 rounded-md bg-[#0866FF] hover:bg-[#0756d6] text-white font-semibold disabled:opacity-40">Xac nhan</button></div>
      </div>
    </div>
  );
});
