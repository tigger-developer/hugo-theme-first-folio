# shellcheck shell=bash
# ABOUTME: RT-70.17 - Home Screen share control falls back to copying the page link.
# ABOUTME: The control remains useful when native Web Share is unavailable.

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
  this.listeners = {};
  this.dataset = {};
  this.classList = { toggle: function () {}, add: function () {}, remove: function () {} };
}
FakeElement.prototype.addEventListener = function (name, callback) {
  this.listeners[name] = this.listeners[name] || [];
  this.listeners[name].push(callback);
};
FakeElement.prototype.dispatch = function (name) {
  (this.listeners[name] || []).forEach(function (callback) {
    callback({ currentTarget: this, target: this, preventDefault: function () {} });
  }, this);
};

const feedback = new FakeElement();
const shareButton = new FakeElement();
shareButton.dataset = {
  copyValue: "https://example.com/audiobook-demo/",
  shareUrl: "https://example.com/audiobook-demo/",
  audioAssistCopied: "copied"
};
shareButton.querySelector = function (selector) {
  if (selector === "[data-audio-assist-feedback]") {
    return feedback;
  }
  return null;
};

globalThis.document = {
  querySelectorAll: function (selector) {
    if (selector === ".audiobook-player") {
      return [];
    }
    if (selector === "[data-audio-assist-copy][data-copy-value]") {
      return [];
    }
    if (selector === "[data-homescreen-instruction]") {
      return [];
    }
    if (selector === "[data-audio-web-share]") {
      return [shareButton];
    }
    return [];
  }
};
globalThis.navigator = {
  clipboard: {
    copied: "",
    writeText: function (value) {
      this.copied = value;
      return { then: function (success) { success(); return { catch: function () {} }; } };
    }
  }
};
globalThis.window = {
  location: { href: "https://example.com/fallback/" },
  setTimeout: function () {}
};

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
shareButton.dispatch("click");

if (globalThis.navigator.clipboard.copied !== "https://example.com/audiobook-demo/") {
  throw new Error("share fallback did not copy the page link");
}
if (feedback.textContent.length === 0) {
  throw new Error("share fallback did not expose feedback");
}
JXA
}
