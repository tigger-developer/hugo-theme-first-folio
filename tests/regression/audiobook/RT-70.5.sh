# shellcheck shell=bash
# ABOUTME: RT-70.5 - ended playback advances to the next item from zero.
# ABOUTME: Auto progression preserves the beginning of the next chapter or episode.

run_test() {
    osascript -l JavaScript <<JXA
const app = Application.currentApplication();
app.includeStandardAdditions = true;

function readText(path) {
  return $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null).js;
}

function FakeElement() {
  this.textContent = "";
  this.hidden = false;
  this.disabled = false;
  this.classList = { toggle: function () {}, add: function () {}, remove: function () {} };
  this.listeners = {};
  this.dataset = {};
}
FakeElement.prototype.addEventListener = function (name, callback) {
  this.listeners[name] = this.listeners[name] || [];
  this.listeners[name].push(callback);
};
FakeElement.prototype.dispatch = function (name) {
  (this.listeners[name] || []).forEach(function (callback) {
    callback({ currentTarget: this });
  }, this);
};

function FakeAudio() {
  FakeElement.call(this);
  this.dataset = { audiobookId: "fixture-book", chapterId: "chapter-1" };
  this.currentTime = 80;
  this.duration = 120;
  this.paused = false;
  this.readyState = 1;
  this.playCount = 0;
}
FakeAudio.prototype = Object.create(FakeElement.prototype);
FakeAudio.prototype.load = function () {};
FakeAudio.prototype.play = function () {
  this.playCount += 1;
  this.paused = false;
  this.dispatch("play");
  return { catch: function () {} };
};
FakeAudio.prototype.pause = function () {
  this.paused = true;
  this.dispatch("pause");
};

const audio = new FakeAudio();
const source = new FakeElement();
source.setAttribute = function (name, value) {
  this[name] = value;
};

function track(id) {
  const button = new FakeElement();
  button.dataset = {
    audiobookTrack: "",
    audiobookId: "fixture-book",
    chapterId: id,
    chapterTitle: id,
    chapterLabel: id,
    chapterSrc: "/" + id + ".m4a",
    chapterMimeType: "audio/mp4",
    chapterDuration: "00:02:00"
  };
  return button;
}
const tracks = [track("chapter-1"), track("chapter-2")];

globalThis.document = {
  querySelectorAll: function (selector) {
    if (selector === ".audiobook-player") {
      return [{ querySelectorAll: this.querySelectorAll.bind(this), querySelector: this.querySelector.bind(this) }];
    }
    if (selector === "[data-audiobook-track]") {
      return tracks;
    }
    if (selector === "[data-audio-assist-copy][data-copy-value]") {
      return [];
    }
    return [];
  },
  querySelector: function (selector) {
    const elements = {
      "audio[data-audiobook-id][data-chapter-id]": audio,
      "[data-audiobook-play-toggle]": new FakeElement(),
      "[data-audiobook-active-label]": new FakeElement(),
      "[data-audiobook-active-title]": new FakeElement(),
      "[data-audiobook-active-summary]": new FakeElement(),
      "[data-audiobook-active-progress]": new FakeElement(),
      "[data-audiobook-active-duration]": new FakeElement(),
      "[data-audiobook-source]": source,
      "[data-audiobook-previous]": new FakeElement(),
      "[data-audiobook-next]": new FakeElement()
    };
    return elements[selector] || null;
  }
};
globalThis.localStorage = {
  values: { "first-folio:audiobook:fixture-book:chapter-2": "11" },
  getItem: function (key) { return Object.prototype.hasOwnProperty.call(this.values, key) ? this.values[key] : null; },
  setItem: function (key, value) { this.values[key] = String(value); },
  removeItem: function (key) { delete this.values[key]; }
};

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));

audio.dispatch("ended");
if (audio.dataset.chapterId !== "chapter-2") {
  throw new Error("ended item did not advance to next item");
}
if (audio.currentTime !== 0) {
  throw new Error("next item did not start at zero");
}
if (audio.playCount !== 1) {
  throw new Error("next item did not start playback");
}
if (globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-2"]) {
  throw new Error("stale next-item position was not cleared");
}
JXA
}
