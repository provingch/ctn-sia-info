// Fase 1: solo lo necesario para que el navegador considere el sitio "instalable".
// No cachea nada todavía — eso es Fase 2.
self.addEventListener('install', (event) => {
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(self.clients.claim());
});

self.addEventListener('fetch', () => {
  // Passthrough — sin estrategia de cache en esta fase.
});
