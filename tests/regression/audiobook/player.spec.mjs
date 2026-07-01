// ABOUTME: Browser-level regression tests for the audiobook localStorage player helper.
// ABOUTME: Serves a minimal page and executes the real static player script in Chromium.
import { test, expect } from '@playwright/test';
import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const thisFile = fileURLToPath(import.meta.url);
const themeRoot = path.resolve(path.dirname(thisFile), '../../..');
const playerPath = path.join(themeRoot, 'static/js/audiobook-player.js');

let server;
let baseURL;

async function pageHtml() {
  return `<!doctype html>
<html>
<body>
  <main class="audiobook-page" data-audiobook-id="demo-book">
    <audio controls data-audiobook-id="demo-book" data-chapter-id="episode-1">
      <source src="/audio/audiobook-demo/episode-1.m4a" type="audio/mp4">
    </audio>
  </main>
  <script src="/js/audiobook-player.js"></script>
</body>
</html>`;
}

test.beforeAll(async () => {
  server = createServer(async (request, response) => {
    if (request.url === '/js/audiobook-player.js') {
      response.setHeader('content-type', 'application/javascript');
      response.end(await readFile(playerPath, 'utf8'));
      return;
    }
    response.setHeader('content-type', 'text/html');
    response.end(await pageHtml());
  });

  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', resolve);
  });
  const address = server.address();
  baseURL = `http://127.0.0.1:${address.port}/`;
});

test.afterAll(async () => {
  await new Promise((resolve) => server.close(resolve));
});

test('RT-62.17 stores playback position with stable book and chapter keys', async ({ page }) => {
  await page.goto(baseURL);
  await page.locator('audio[data-chapter-id="episode-1"]').evaluate((audio) => {
    audio.currentTime = 37;
    audio.dispatchEvent(new Event('timeupdate'));
  });

  await expect.poll(() => page.evaluate(() => localStorage.getItem('first-folio:audiobook:demo-book:episode-1'))).toBe('37');
});

test('RT-62.18 restores stored playback position for matching audio element', async ({ page }) => {
  await page.addInitScript(() => {
    localStorage.setItem('first-folio:audiobook:demo-book:episode-1', '42');
  });
  await page.goto(baseURL);
  await page.locator('audio[data-chapter-id="episode-1"]').evaluate((audio) => {
    audio.dispatchEvent(new Event('loadedmetadata'));
  });

  await expect(page.locator('audio[data-chapter-id="episode-1"]')).toHaveJSProperty('currentTime', 42);
});

test('RT-62.19 ignores invalid or missing stored positions without blocking controls', async ({ page }) => {
  await page.addInitScript(() => {
    localStorage.setItem('first-folio:audiobook:demo-book:episode-1', 'not-a-number');
  });
  await page.goto(baseURL);
  await page.locator('audio[data-chapter-id="episode-1"]').evaluate((audio) => {
    audio.dispatchEvent(new Event('loadedmetadata'));
  });

  await expect(page.locator('audio[controls][data-chapter-id="episode-1"]')).toHaveCount(1);
  await expect(page.locator('audio[data-chapter-id="episode-1"]')).toHaveJSProperty('currentTime', 0);
});
