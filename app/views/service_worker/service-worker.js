const VERSION = 'v1';
const NAME = 'DogrunConnect-';
const CACHE_NAME = NAME + VERSION;
const urlsToCache = [
  "./offline.html"
];

// Service Workerのへのファイルをインストール
self.addEventListener('install', function (event) {
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      console.log('Opened cache');
      return cache.addAll(urlsToCache);
    })
  );
});

// リクエストされたファイルがService Workerにキャッシュ済みの場合、キャッシュからレスポンスを返す
self.addEventListener('fetch', function (event) {
  if (event.request.cache === 'only-if-cached' && event.request.mode !== 'same-origin')
    return;
  event.respondWith(
    cache.match(event.request).then(function (response) {
      if (response) {
        return response;
      }
      return fetch(event.request);
      })
    );
  });

  // Cache Storageにキャッシュされているserviceworkerのkeyに変更があった場合
  // 新しいバージョンをインストール後、急バージョンのキャッシュを削除する
  // (このファイルでは CACHE_NAMEをkeyの値とみなし、変更を検知する)
  self.addEventListener('activate', event => {
    event.waitUntil(
      cache.keys().then(keys => Promise.all(
        keys.map(key => {
          if (!CACHE_NAME.includes(key)) {
            return cache.delete(key);
          }
        })
      )).then(() => {
        console.log(CACHE_NAME + "activated");
      })
    );
  });
