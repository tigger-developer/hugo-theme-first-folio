# shellcheck shell=bash
# ABOUTME: RT-70.14 - platform-specific Home Screen instructions are selected by script.
# ABOUTME: iOS, Android, and generic browser families receive distinct visible guidance.

run_test() {
    osascript -l JavaScript <<JXA
const app = Application.currentApplication();
app.includeStandardAdditions = true;

function readText(path) {
  return $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null).js;
}

function FakeElement(platform) {
  this.dataset = { homescreenInstruction: platform };
  this.hidden = true;
  this.textContent = platform;
  this.listeners = {};
  this.classList = { toggle: function () {}, add: function () {}, remove: function () {} };
}
FakeElement.prototype.addEventListener = function () {};

const ios = new FakeElement("ios");
const android = new FakeElement("android");
const generic = new FakeElement("generic");

globalThis.document = {
  querySelectorAll: function (selector) {
    if (selector === ".audiobook-player") {
      return [];
    }
    if (selector === "[data-audio-assist-copy][data-copy-value]") {
      return [];
    }
    if (selector === "[data-homescreen-instruction]") {
      return [ios, android, generic];
    }
    return [];
  }
};
globalThis.navigator = {
  userAgent: "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X)",
  platform: "iPhone"
};
globalThis.window = {};

eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
if (ios.hidden !== false || android.hidden !== true || generic.hidden !== true) {
  throw new Error("iOS instruction was not selected");
}

globalThis.navigator.userAgent = "Mozilla/5.0 (Linux; Android 15; Pixel)";
globalThis.navigator.platform = "Linux armv8l";
ios.hidden = true;
android.hidden = true;
generic.hidden = true;
eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
if (android.hidden !== false || ios.hidden !== true || generic.hidden !== true) {
  throw new Error("Android instruction was not selected");
}

globalThis.navigator.userAgent = "Mozilla/5.0 (X11; Linux x86_64)";
globalThis.navigator.platform = "Linux x86_64";
ios.hidden = true;
android.hidden = true;
generic.hidden = true;
eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
if (generic.hidden !== false || ios.hidden !== true || android.hidden !== true) {
  throw new Error("generic instruction was not selected");
}
JXA
}
