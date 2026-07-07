# shellcheck shell=bash
# ABOUTME: RT-64.11 - audiobook player advances to the next chapter in DOM order.

run_test() {
    osascript -l JavaScript <<JXA
const app = Application.currentApplication();
app.includeStandardAdditions = true;

function readText(path) {
  return $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null).js;
}

function FakeAudio(chapterId) {
  this.dataset = { audiobookId: "fixture-book", chapterId: chapterId };
  this.currentTime = 0;
  this.paused = true;
  this.readyState = 1;
  this.playCount = 0;
  this.pauseCount = 0;
  this.listeners = {};
}

FakeAudio.prototype.addEventListener = function (name, callback) {
  this.listeners[name] = this.listeners[name] || [];
  this.listeners[name].push(callback);
};

FakeAudio.prototype.dispatch = function (name) {
  (this.listeners[name] || []).forEach(function (callback) {
    callback();
  });
};

FakeAudio.prototype.play = function () {
  this.playCount += 1;
  this.paused = false;
  this.dispatch("play");
  return { catch: function () {} };
};

FakeAudio.prototype.pause = function () {
  this.pauseCount += 1;
  this.paused = true;
  this.dispatch("pause");
};

const audios = [new FakeAudio("chapter-1"), new FakeAudio("chapter-2"), new FakeAudio("chapter-3")];

globalThis.document = {
  querySelectorAll: function (selector) {
    if (selector === "audio[data-audiobook-id][data-chapter-id]") {
      return audios;
    }
    if (selector === "[data-feed-copy][data-feed-url]") {
      return [];
    }
    throw new Error("unexpected selector: " + selector);
  }
};

globalThis.localStorage = {
  values: { "first-folio:audiobook:fixture-book:chapter-2": "1" },
  getItem: function (key) {
    return Object.prototype.hasOwnProperty.call(this.values, key) ? this.values[key] : null;
  },
  setItem: function (key, value) {
    this.values[key] = String(value);
  },
  removeItem: function (key) {
    delete this.values[key];
  }
};

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));

if (audios[1].currentTime !== 1) {
  throw new Error("test setup did not restore stored chapter position");
}

audios[0].dispatch("ended");
if (audios[1].playCount !== 1) {
  throw new Error("first chapter did not advance to second chapter");
}
if (audios[1].currentTime !== 0) {
  throw new Error("advanced chapter did not start from the beginning");
}
if (globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-2"]) {
  throw new Error("advanced chapter kept stale stored position");
}

audios[2].paused = false;
audios[1].play();
if (audios[2].pauseCount !== 1) {
  throw new Error("playing one chapter did not pause another active chapter");
}

audios[2].dispatch("ended");
if (audios[0].playCount !== 0 || audios[2].playCount !== 0) {
  throw new Error("last chapter unexpectedly advanced");
}
JXA
}
