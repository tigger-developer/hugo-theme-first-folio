# shellcheck shell=bash
# ABOUTME: RT-70.11 - subscription-panel copy interaction gives clear feedback.
# ABOUTME: Clicking the panel body copies the podcast feed link where clipboard access exists.

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

const copyTarget = new FakeElement();
copyTarget.dataset = {
  audioAssistCopy: "",
  copyValue: "https://example.com/podcast-demo/feed.xml",
  audioAssistCopied: "copied"
};
const feedback = new FakeElement();
copyTarget.querySelector = function (selector) {
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
      return [copyTarget];
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
globalThis.window = { setTimeout: function () {} };

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
copyTarget.dispatch("click");

if (globalThis.navigator.clipboard.copied !== "https://example.com/podcast-demo/feed.xml") {
  throw new Error("feed link was not copied");
}
if (feedback.textContent.length === 0) {
  throw new Error("copy feedback was not shown");
}
JXA
}
