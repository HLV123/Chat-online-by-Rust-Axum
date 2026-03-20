/**
 * prerender.mjs
 * Sinh dist/index.html bằng cách SSR-render route gốc (/).
 *
 * Chạy SAU khi đã build cả client lẫn SSR entry:
 *   bun run build.client
 *   bun run build.preview
 *   bun prerender.mjs
 *
 * Kết quả: dist/index.html (Qwik SSR shell, dùng làm SPA fallback)
 */

import { createServer } from "node:http";
import { writeFileSync } from "node:fs";

// Sau khi build.preview, Qwik output SSR entry vào server/entry.preview.js
let routerFn, notFoundFn;
try {
  const mod = await import("./server/entry.preview.js");
  routerFn = mod.router;
  notFoundFn = mod.notFound;
} catch (e) {
  console.error("LOI: Khong load duoc server/entry.preview.js");
  console.error("  -> Chay 'bun run build.preview' truoc khi chay script nay.");
  console.error("  -> Chi tiet:", e.message);
  process.exit(1);
}

// Khoi dong server tam de Qwik City render qua HTTP
const server = createServer((req, res) => {
  routerFn(req, res, () => {
    if (notFoundFn) notFoundFn(req, res, () => {});
  });
});

await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
const { port } = server.address();

console.log(`  Dang render http://127.0.0.1:${port}/ ...`);

let html;
try {
  const res = await fetch(`http://127.0.0.1:${port}/`);
  html = await res.text();
} catch (e) {
  server.close();
  console.error("LOI: Khong the fetch HTML tu preview server:", e.message);
  process.exit(1);
}

server.close();

// Kiem tra output co phai Qwik SSR HTML khong
if (!html.includes("q:container")) {
  console.error("LOI: HTML tra ve khong chua q:container — SSR co the da fail.");
  console.error("  -> Kiem tra lai build.preview co loi khong.");
  process.exit(1);
}

writeFileSync("./dist/index.html", html, "utf-8");
console.log(`OK: dist/index.html da duoc tao (${(html.length / 1024).toFixed(1)} KB)`);
