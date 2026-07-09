// ABOUTME: JXA regression harness for issue #72 audio player behaviours.
// ABOUTME: Runs the real player script against a fake DOM without Node.
ObjC.import("Foundation");

function env(name) {
  const value = $.NSProcessInfo.processInfo.environment.objectForKey(name);
  return value ? ObjC.unwrap(value) : "";
}

function readText(path) {
  return $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null).js;
}

function FakeClassList() {
  this.values = {};
}
FakeClassList.prototype.toggle = function (name, active) {
  this.values[name] = Boolean(active);
};
FakeClassList.prototype.add = function (name) {
  this.values[name] = true;
};
FakeClassList.prototype.remove = function (name) {
  delete this.values[name];
};

function FakeElement(name) {
  this.name = name || "element";
  this.textContent = "";
  this.hidden = false;
  this.disabled = false;
  this.value = "0";
  this.max = "0";
  this.dataset = {};
  this.listeners = {};
  this.attributes = {};
  this.classList = new FakeClassList();
}
FakeElement.prototype.addEventListener = function (name, callback) {
  this.listeners[name] = this.listeners[name] || [];
  this.listeners[name].push(callback);
};
FakeElement.prototype.dispatch = function (name, event) {
  const payload = event || { currentTarget: this, target: this, preventDefault: function () {} };
  (this.listeners[name] || []).forEach(function (callback) {
    callback(payload);
  });
};
FakeElement.prototype.setAttribute = function (name, value) {
  this.attributes[name] = String(value);
};
FakeElement.prototype.removeAttribute = function (name) {
  delete this.attributes[name];
};
FakeElement.prototype.querySelector = function () {
  return null;
};
FakeElement.prototype.querySelectorAll = function () {
  return [];
};

function FakeAudio() {
  FakeElement.call(this, "audio");
  this.dataset = { audiobookId: "fixture-book", chapterId: "chapter-1" };
  this.currentTime = 0;
  this.duration = 600;
  this.paused = true;
  this.readyState = 1;
  this.playbackRate = 1;
  this.playCount = 0;
  this.pauseCount = 0;
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
  this.pauseCount += 1;
  this.paused = true;
  this.dispatch("pause");
};

function track(id, label) {
  const button = new FakeElement(id);
  const row = new FakeElement(id + "-row");
  const resume = new FakeElement(id + "-resume");
  row.querySelector = function (selector) {
    return selector === "[data-audiobook-track-resume]" ? resume : null;
  };
  button.closest = function (selector) {
    return selector === "[data-audiobook-track-row]" ? row : null;
  };
  button.dataset = {
    audiobookTrack: "",
    audiobookId: "fixture-book",
    chapterId: id,
    chapterTitle: label + " Title",
    chapterLabel: label,
    chapterSrc: "/" + id + ".m4a",
    chapterMimeType: "audio/mp4",
    chapterDuration: "00:10:00"
  };
  button.row = row;
  button.resume = resume;
  return button;
}

function makeButton(name, dataset) {
  const button = new FakeElement(name);
  button.dataset = dataset || {};
  return button;
}

function makeHarness(storageValues) {
  const audio = new FakeAudio();
  const source = new FakeElement("source");
  const tracks = [track("chapter-1", "Chapter 1"), track("chapter-2", "Chapter 2"), track("chapter-3", "Chapter 3")];
  const speedButtons = ["0.75", "1", "1.25", "1.5", "2"].map(function (rate) {
    return makeButton("speed-" + rate, { audiobookSpeed: rate });
  });
  const sleepMinuteButtons = ["15", "30"].map(function (minutes) {
    return makeButton("sleep-" + minutes, { audiobookSleepMinutes: minutes });
  });
  const startButtons = tracks.map(function (item) {
    return makeButton("start-" + item.dataset.chapterId, { chapterId: item.dataset.chapterId });
  });
  const completeButtons = tracks.map(function (item) {
    return makeButton("complete-" + item.dataset.chapterId, { chapterId: item.dataset.chapterId });
  });
  const queueUpButtons = tracks.map(function (item) {
    return makeButton("up-" + item.dataset.chapterId, { chapterId: item.dataset.chapterId });
  });
  const queueDownButtons = tracks.map(function (item) {
    return makeButton("down-" + item.dataset.chapterId, { chapterId: item.dataset.chapterId });
  });
  const elements = {
    "audio[data-audiobook-id][data-chapter-id]": audio,
    "[data-audiobook-source]": source,
    "[data-audiobook-play-toggle]": new FakeElement("play"),
    "[data-audiobook-play-label]": new FakeElement("play-label"),
    "[data-audiobook-play-icon]": new FakeElement("play-icon"),
    "[data-audiobook-previous]": new FakeElement("previous"),
    "[data-audiobook-next]": new FakeElement("next"),
    "[data-audiobook-active-label]": new FakeElement("active-label"),
    "[data-audiobook-active-title]": new FakeElement("active-title"),
    "[data-audiobook-active-summary]": new FakeElement("active-summary"),
    "[data-audiobook-active-progress]": new FakeElement("active-progress"),
    "[data-audiobook-active-duration]": new FakeElement("active-duration"),
    "[data-audiobook-scrubber]": new FakeElement("scrubber"),
    "[data-audiobook-feedback]": new FakeElement("feedback"),
    "[data-audiobook-error]": new FakeElement("error"),
    "[data-audiobook-up-next]": new FakeElement("up-next"),
    "[data-audiobook-resume-work]": new FakeElement("resume-work"),
    "[data-audiobook-sleep-end]": makeButton("sleep-end"),
    "[data-audiobook-sleep-cancel]": makeButton("sleep-cancel"),
    "[data-audiobook-queue-reset]": makeButton("queue-reset")
  };
  const player = new FakeElement("player");
  player.dataset = {
    audiobookId: "fixture-book",
    audiobookTitle: "Fixture Work",
    audiobookAuthor: "Fixture Author",
    audiobookArtwork: "/cover.jpg"
  };
  player.querySelector = function (selector) {
    return elements[selector] || null;
  };
  player.querySelectorAll = function (selector) {
    if (selector === "[data-audiobook-track]") { return tracks; }
    if (selector === "[data-audiobook-speed]") { return speedButtons; }
    if (selector === "[data-audiobook-sleep-minutes]") { return sleepMinuteButtons; }
    if (selector === "[data-audiobook-track-start]") { return startButtons; }
    if (selector === "[data-audiobook-track-complete]") { return completeButtons; }
    if (selector === "[data-audiobook-queue-up]") { return queueUpButtons; }
    if (selector === "[data-audiobook-queue-down]") { return queueDownButtons; }
    if (selector === "[data-audiobook-seek]") {
      return [makeButton("back", { audiobookSeek: "-30" }), makeButton("forward", { audiobookSeek: "15" })];
    }
    return [];
  };

  const keyEvents = [];
  const timeouts = [];
  globalThis.document = {
    addEventListener: function (name, callback) {
      if (name === "keydown") {
        keyEvents.push(callback);
      }
    },
    querySelectorAll: function (selector) {
      if (selector === ".audiobook-player") { return [player]; }
      if (selector === "[data-audio-assist-copy][data-copy-value]") { return []; }
      if (selector === "[data-feed-copy][data-feed-url]") { return []; }
      if (selector === "[data-homescreen-instruction]") { return []; }
      if (selector === "[data-audio-web-share]") { return []; }
      if (selector === ".audiobook-sidebar details.audiobook-assist-panel") { return []; }
      return [];
    }
  };
  globalThis.localStorage = {
    values: storageValues || {},
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
  globalThis.window = {
    setTimeout: function (callback) {
      timeouts.push(callback);
      return timeouts.length;
    },
    clearTimeout: function () {},
    matchMedia: function () {
      return { matches: false, addEventListener: function () {} };
    },
    location: { href: "https://example.com/audio/" }
  };
  globalThis.navigator = {
    userAgent: "JXA",
    platform: "MacIntel",
    mediaSession: {
      metadata: null,
      handlers: {},
      setActionHandler: function (name, callback) {
        this.handlers[name] = callback;
      }
    }
  };
  globalThis.MediaMetadata = function (metadata) {
    this.title = metadata.title;
    this.artist = metadata.artist;
    this.album = metadata.album;
    this.artwork = metadata.artwork;
  };

  eval(readText(env("THEME_ROOT") + "/static/js/audiobook-player.js"));
  return {
    audio: audio,
    source: source,
    tracks: tracks,
    speedButtons: speedButtons,
    sleepMinuteButtons: sleepMinuteButtons,
    sleepEndButton: elements["[data-audiobook-sleep-end]"],
    sleepCancelButton: elements["[data-audiobook-sleep-cancel]"],
    startButtons: startButtons,
    completeButtons: completeButtons,
    queueUpButtons: queueUpButtons,
    queueDownButtons: queueDownButtons,
    queueResetButton: elements["[data-audiobook-queue-reset]"],
    feedback: elements["[data-audiobook-feedback]"],
    error: elements["[data-audiobook-error]"],
    upNext: elements["[data-audiobook-up-next]"],
    resumeWork: elements["[data-audiobook-resume-work]"],
    keydown: function (key, target) {
      const event = {
        key: key,
        target: target || {},
        prevented: false,
        preventDefault: function () { this.prevented = true; }
      };
      keyEvents.forEach(function (callback) { callback(event); });
      return event;
    },
    runTimeouts: function () {
      while (timeouts.length > 0) {
        timeouts.shift()();
      }
    }
  };
}

function assert(condition, message) {
  if (!condition) {
    throw new Error(message);
  }
}

function scenarioSpeed() {
  const h = makeHarness({});
  h.speedButtons[3].dispatch("click");
  assert(h.audio.playbackRate === 1.5, "speed button did not set playbackRate");
  assert(globalThis.localStorage.values["first-folio:audiobook:fixture-book:speed"] === "1.5", "speed was not persisted");
  h.tracks[1].dispatch("click");
  assert(h.audio.playbackRate === 1.5, "speed was not reapplied after item change");
  assert(h.feedback.textContent === "Speed 1.5x", "speed feedback was not shown");
}

function scenarioSleepMinute() {
  const h = makeHarness({});
  h.audio.currentTime = 123;
  h.audio.play();
  h.sleepMinuteButtons[0].dispatch("click");
  h.runTimeouts();
  assert(h.audio.paused, "minute sleep timer did not pause audio");
  assert(globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-1"] === "123", "minute sleep timer did not store position");
}

function scenarioSleepEnd() {
  const h = makeHarness({});
  h.audio.play();
  h.sleepEndButton.dispatch("click");
  h.audio.dispatch("ended");
  assert(h.audio.dataset.chapterId === "chapter-1", "end-of-item sleep advanced to next item");
  assert(h.audio.paused, "end-of-item sleep did not pause");
  h.sleepCancelButton.dispatch("click");
  assert(h.feedback.textContent === "Sleep timer cancelled", "sleep cancellation feedback missing");
}

function scenarioResume() {
  const h = makeHarness({ "first-folio:audiobook:fixture-book:chapter-2": "82" });
  assert(h.resumeWork.textContent.indexOf("Chapter 2") !== -1, "work resume target did not use stored item");
  assert(h.tracks[1].resume.textContent.indexOf("1:22") !== -1, "item resume target did not show stored time");
  h.startButtons[1].dispatch("click");
  assert(h.audio.dataset.chapterId === "chapter-2", "restart did not select item");
  assert(h.audio.currentTime === 0, "restart did not seek to zero");
  assert(!globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-2"], "restart did not clear stored position");
  globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-3"] = "9";
  h.completeButtons[2].dispatch("click");
  assert(!globalThis.localStorage.values["first-folio:audiobook:fixture-book:chapter-3"], "complete did not clear stored position");
  assert(globalThis.localStorage.values["first-folio:audiobook:fixture-book:complete:chapter-3"] === "1", "complete marker was not stored");
}

function scenarioQueue() {
  const h = makeHarness({});
  h.queueUpButtons[2].dispatch("click");
  assert(globalThis.localStorage.values["first-folio:audiobook:fixture-book:queue"].indexOf("chapter-3") !== -1, "queue order was not stored");
  assert(h.upNext.textContent.indexOf("Chapter 3") !== -1, "up-next did not follow adjusted queue");
  h.audio.play();
  h.audio.dispatch("ended");
  assert(h.audio.dataset.chapterId === "chapter-3", "auto-advance did not follow adjusted queue");
  h.queueResetButton.dispatch("click");
  assert(!globalThis.localStorage.values["first-folio:audiobook:fixture-book:queue"], "queue reset did not clear stored order");
}

function scenarioKeyboard() {
  const h = makeHarness({});
  h.keydown(" ");
  assert(!h.audio.paused, "space did not toggle play");
  h.audio.currentTime = 100;
  h.keydown("h");
  assert(h.audio.currentTime === 70, "h did not seek backward");
  h.keydown("l");
  assert(h.audio.currentTime === 85, "l did not seek forward");
  h.keydown("j");
  assert(h.audio.dataset.chapterId === "chapter-2", "j did not select next item");
  h.keydown("k");
  assert(h.audio.dataset.chapterId === "chapter-1", "k did not select previous item");
  h.keydown("=");
  assert(h.audio.playbackRate === 1.25, "equals did not increase speed");
  const event = h.keydown(" ", { tagName: "input" });
  assert(!event.prevented, "keyboard handler intercepted form field typing");
}

function scenarioMedia() {
  const h = makeHarness({});
  assert(globalThis.navigator.mediaSession.metadata.title.indexOf("Chapter 1") !== -1, "media metadata missing active item");
  assert(typeof globalThis.navigator.mediaSession.handlers.play === "function", "play handler missing");
  assert(typeof globalThis.navigator.mediaSession.handlers.seekbackward === "function", "seekbackward handler missing");
  h.tracks[1].dispatch("click");
  assert(globalThis.navigator.mediaSession.metadata.title.indexOf("Chapter 2") !== -1, "media metadata did not update after item change");
}

function scenarioError() {
  const h = makeHarness({});
  h.audio.dispatch("error");
  assert(h.error.textContent.indexOf("Could not play Chapter 1") !== -1, "item-specific error was not shown");
  h.tracks[1].dispatch("click");
  assert(h.error.textContent === "", "selecting another item did not clear error");
}

function run(argv) {
  const scenarios = {
    speed: scenarioSpeed,
    sleepMinute: scenarioSleepMinute,
    sleepEnd: scenarioSleepEnd,
    resume: scenarioResume,
    queue: scenarioQueue,
    keyboard: scenarioKeyboard,
    media: scenarioMedia,
    error: scenarioError
  };
  const name = argv[0];
  assert(scenarios[name], "unknown RT-72 scenario: " + name);
  scenarios[name]();
}
