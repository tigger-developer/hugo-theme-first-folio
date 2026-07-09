# shellcheck shell=bash
# ABOUTME: RT-70.3 - unified audio player keeps existing localStorage keys.
# ABOUTME: Stored positions restore on the active audio element.

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
  this.currentTime = 0;
  this.duration = 120;
  this.paused = true;
  this.readyState = 1;
  this.src = "";
}

FakeAudio.prototype = Object.create(FakeElement.prototype);
FakeAudio.prototype.play = function () {
  this.paused = false;
  this.dispatch("play");
  return { catch: function () {} };
};
FakeAudio.prototype.pause = function () {
  this.paused = true;
  this.dispatch("pause");
};

const audio = new FakeAudio();
const trackButton = new FakeElement();
trackButton.dataset = {
  audiobookTrack: "",
  audiobookId: "fixture-book",
  chapterId: "chapter-1",
  chapterTitle: "Chapter One",
  chapterLabel: "Chapter 1",
  chapterSrc: "/chapter-one.m4a",
  chapterMimeType: "audio/mp4",
  chapterDuration: "00:02:00"
};

globalThis.document = {
  querySelectorAll: function (selector) {
    if (selector === ".audiobook-player") {
      return [{ querySelectorAll: this.querySelectorAll.bind(this), querySelector: this.querySelector.bind(this) }];
    }
    if (selector === "[data-audiobook-track]") {
      return [trackButton];
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
      "[data-audiobook-source]": new FakeElement(),
      "[data-audiobook-previous]": new FakeElement(),
      "[data-audiobook-next]": new FakeElement()
    };
    if (selector === "[data-audiobook-source]") {
      elements[selector].setAttribute = function (name, value) {
        this[name] = value;
      };
    }
    return elements[selector] || null;
  }
};

globalThis.localStorage = {
  values: { "first-folio:audiobook:fixture-book:chapter-1": "37" },
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

audio.dispatch("loadedmetadata");
if (audio.currentTime !== 37) {
  throw new Error("stored position did not restore with existing key");
}

audio.currentTime = 41;
audio.dispatch("timeupdate");
if (globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-1"] !== "41") {
  throw new Error("position was not stored with existing key");
}
JXA
}
