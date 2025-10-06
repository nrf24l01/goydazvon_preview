// Service Worker to cache HLS playlist and segments for offline playback
const CACHE_NAME = 'goydazvon-video-cache-v1';

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return fetch('/rick/playlist.m3u8')
        .then(response => response.text())
        .then(body => {
          // parse playlist lines for segment URIs
          const lines = body.split(/\r?\n/);
          const segmentUrls = lines
            .filter(line => line && !line.startsWith('#'))
            .map(uri => uri.startsWith('http') ? uri : `/rick/${uri}`);
          return cache.addAll(['/rick/playlist.m3u8', ...segmentUrls]);
        });
    })
  );
});

self.addEventListener('fetch', event => {
  const url = new URL(event.request.url);
  if (url.pathname.startsWith('/rick/')) {
    event.respondWith(
      caches.match(event.request).then(cached => cached || fetch(event.request))
    );
  }
});
