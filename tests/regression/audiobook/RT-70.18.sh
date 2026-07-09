# shellcheck shell=bash
# ABOUTME: RT-70.18 - mobile audio pages collapse secondary listening panels.
# ABOUTME: Desktop audio pages keep the sidebar panels expanded.

run_test() {
    osascript -l JavaScript <<JXA
const app = Application.currentApplication();
app.includeStandardAdditions = true;

function readText(path) {
  return $.NSString.stringWithContentsOfFileEncodingError(path, $.NSUTF8StringEncoding, null).js;
}

function FakeDetails() {
  this.open = true;
}
FakeDetails.prototype.removeAttribute = function (name) {
  if (name === "open") {
    this.open = false;
  }
};
FakeDetails.prototype.setAttribute = function (name) {
  if (name === "open") {
    this.open = true;
  }
};

function runWithViewport(isMobile) {
  const panels = [new FakeDetails(), new FakeDetails()];
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
        return [];
      }
      if (selector === ".audiobook-sidebar details.audiobook-assist-panel") {
        return panels;
      }
      return [];
    }
  };
  globalThis.navigator = {
    userAgent: "Mozilla/5.0",
    platform: "MacIntel"
  };
  globalThis.window = {
    matchMedia: function (query) {
      if (query !== "(max-width: 55.99rem)") {
        throw new Error("unexpected media query: " + query);
      }
      return {
        matches: isMobile,
        addEventListener: function () {}
      };
    }
  };

  eval(readText("${THEME_ROOT}/static/js/audiobook-player.js"));
  return panels;
}

const mobilePanels = runWithViewport(true);
if (mobilePanels.some(function (panel) { return panel.open; })) {
  throw new Error("mobile panels should be collapsed");
}

const desktopPanels = runWithViewport(false);
if (desktopPanels.some(function (panel) { return !panel.open; })) {
  throw new Error("desktop panels should stay expanded");
}
JXA
}
