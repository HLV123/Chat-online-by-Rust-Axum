
export function randomNickname() {
  const num = Math.floor(Math.random() * 999) + 1;
  return `Nguoi_La_${num}`;
}

export function avatarColor(name) {
  const colors = [
    "#0084FF", "#44BEC7", "#FFC300", "#FA3C4C",
    "#D696BB", "#6699CC", "#13CF13", "#FF7E29",
    "#E68585", "#7646FF", "#20CEF5", "#67B868",
    "#E2556B", "#F39D21", "#0099CC", "#FF6F61",
  ];
  let hash = 0x811c9dc5;
  for (let i = 0; i < name.length; i++) {
    hash ^= name.charCodeAt(i);
    hash = (hash * 0x01000193) >>> 0;
  }
  return colors[hash % colors.length];
}

export function avatarInitial(name) {
  if (!name) return "?";
  return name.charAt(0).toUpperCase();
}

export function formatTime(dateStr) {
  if (!dateStr) return "";
  try {
    const d = new Date(dateStr);
    const now = new Date();
    const diffMs = now - d;
    const diffMin = Math.floor(diffMs / 60000);

    if (diffMin < 1) return "Vua xong";
    if (diffMin < 60) return `${diffMin} phut truoc`;

    const isToday = d.toDateString() === now.toDateString();
    if (isToday) {
      return d.toLocaleTimeString("vi-VN", { hour: "2-digit", minute: "2-digit" });
    }

    return d.toLocaleDateString("vi-VN", { day: "2-digit", month: "2-digit", hour: "2-digit", minute: "2-digit" });
  } catch {
    return "";
  }
}
