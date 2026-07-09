# shellcheck shell=bash
# ABOUTME: RT-70.4 - selecting or playing one item keeps a single active audio item.
# ABOUTME: The unified player pauses current playback before changing items.

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
  this.currentTime = 10;
  this.duration = 120;
  this.paused = false;
  this.readyState = 1;
  this.pauseCount = 0;
}
FakeAudio.prototype = Object.create(FakeElement.prototype);
FakeAudio.prototype.load = function () {};
FakeAudio.prototype.play = function () {
  this.paused = false;
  this.dispatch("play");
  return { catch: function () {} };
};
FakeAudio.prototype.pause = function () {
  this.pauseCount += 1;
  this.paused = true;
  this.dispatch("pause");
};

const audio = new FakeAudio();
const source = new FakeElement();
source.setAttribute = function (name, value) {
  this[name] = value;
};

function track(id, title) {
  const button = new FakeElement();
  button.dataset = {
    audiobookTrack: "",
    audiobookId: "fixture-book",
    chapterId: id,
    chapterTitle: title,
    chapterLabel: title,
    chapterSrc: "/" + id + ".m4a",
    chapterMimeType: "audio/mp4",
    chapterDuration: "00:02:00"
  };
  return button;
}
const tracks = [track("chapter-1", "Chapter 1"), track("chapter-2", "Chapter 2")];
const playToggle = new FakeElement();

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
      "[data-audiobook-play-toggle]": playToggle,
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
globalThis.localStorage = { getItem: function () { return null; }, setItem: function () {}, removeItem: function () {} };

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));

tracks[1].dispatch("click");
if (audio.pauseCount !== 1) {
  throw new Error("changing active item did not pause current playback");
}
if (audio.dataset.chapterId !== "chapter-2") {
  throw new Error("active audio did not switch to clicked chapter");
}
JXA
}
