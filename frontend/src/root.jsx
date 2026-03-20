import { component$ } from "@builder.io/qwik";
import {
  QwikCityProvider,
  RouterOutlet,
  ServiceWorkerRegister,
} from "@builder.io/qwik-city";

import "./global.css";

export default component$(() => {
  return (
    <QwikCityProvider>
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="QwikChat — Ung dung chat an danh, khong can dang ky. Chat nhom thoi gian thuc voi WebSocket." />
        <meta property="og:title" content="QwikChat" />
        <meta property="og:description" content="Chat an danh, khong can dang ky" />
        <meta property="og:type" content="website" />
        <title>QwikChat — Chat an danh</title>
        <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
      </head>
      <body class="bg-[#18191A] text-[#E4E6EB]" lang="vi">
        <RouterOutlet />
        <ServiceWorkerRegister />
      </body>
    </QwikCityProvider>
  );
});
