// ABOUTME: Enhances First Folio audio pages with one active player and item selector.
// ABOUTME: Persists listening positions and handles secondary audio-page copy actions.
(function () {
  const storagePrefix = "first-folio:audiobook";
  const legacyAudioSelector = "audio[data-audiobook-id][data-chapter-id]";

  function storageKeyForIds(bookId, chapterId) {
    if (!bookId || !chapterId) {
      return null;
    }
    return `${storagePrefix}:${bookId}:${chapterId}`;
  }

  function storageKey(audio) {
    return storageKeyForIds(audio.dataset.audiobookId, audio.dataset.chapterId);
  }

  function storedPosition(key) {
    try {
      const raw = localStorage.getItem(key);
      const value = Number(raw);
      if (!Number.isFinite(value) || value <= 0) {
        return null;
      }
      return value;
    } catch (_error) {
      return null;
    }
  }

  function setAudioTime(audio, value) {
    try {
      audio.currentTime = value;
    } catch (_error) {
      // Some browsers reject currentTime changes before metadata is ready.
    }
  }

  function restorePosition(audio) {
    const key = storageKey(audio);
    if (!key) {
      return;
    }
    const position = storedPosition(key);
    if (position === null) {
      return;
    }
    setAudioTime(audio, position);
  }

  function storePosition(audio) {
    const key = storageKey(audio);
    if (!key || !Number.isFinite(audio.currentTime) || audio.currentTime <= 0) {
      return;
    }
    try {
      localStorage.setItem(key, String(Math.floor(audio.currentTime)));
    } catch (_error) {
      // Storage can be unavailable in private modes; audio controls should still work.
    }
  }

  function clearPositionForIds(bookId, chapterId) {
    const key = storageKeyForIds(bookId, chapterId);
    if (!key) {
      return;
    }
    try {
      localStorage.removeItem(key);
    } catch (_error) {
      // Storage can be unavailable in private modes; audio controls should still work.
    }
  }

  function clearPosition(audio) {
    clearPositionForIds(audio.dataset.audiobookId, audio.dataset.chapterId);
  }

  function playAudio(audio) {
    const playAttempt = audio.play();
    if (playAttempt && typeof playAttempt.catch === "function") {
      playAttempt.catch(function () {
        // Browsers may block automatic playback; controls remain usable.
      });
    }
  }

  function formatClock(seconds) {
    if (!Number.isFinite(seconds) || seconds <= 0) {
      return "00:00";
    }
    const total = Math.floor(seconds);
    const hours = Math.floor(total / 3600);
    const minutes = Math.floor((total % 3600) / 60);
    const secs = total % 60;
    if (hours > 0) {
      return `${String(hours).padStart(2, "0")}:${String(minutes).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
    }
    return `${String(minutes).padStart(2, "0")}:${String(secs).padStart(2, "0")}`;
  }

  function updateText(element, value) {
    if (!element) {
      return;
    }
    element.textContent = value || "";
    if ("hidden" in element) {
      element.hidden = !value;
    }
  }

  function queryAll(root, selector) {
    try {
      return Array.from(root.querySelectorAll(selector));
    } catch (_error) {
      return [];
    }
  }

  function queryOne(root, selector) {
    try {
      return root.querySelector(selector);
    } catch (_error) {
      return null;
    }
  }

  function wireUnifiedPlayer(player) {
    const audio = queryOne(player, legacyAudioSelector);
    const source = queryOne(player, "[data-audiobook-source]");
    const tracks = queryAll(player, "[data-audiobook-track]");
    const playToggle = queryOne(player, "[data-audiobook-play-toggle]");
    const previousButton = queryOne(player, "[data-audiobook-previous]");
    const nextButton = queryOne(player, "[data-audiobook-next]");
    const seekButtons = queryAll(player, "[data-audiobook-seek]");
    const activeLabel = queryOne(player, "[data-audiobook-active-label]");
    const activeTitle = queryOne(player, "[data-audiobook-active-title]");
    const activeSummary = queryOne(player, "[data-audiobook-active-summary]");
    const activeProgress = queryOne(player, "[data-audiobook-active-progress]");
    const activeDuration = queryOne(player, "[data-audiobook-active-duration]");

    if (!audio || tracks.length === 0) {
      return;
    }

    let activeIndex = Math.max(0, tracks.findIndex(function (track) {
      return track.dataset.chapterId === audio.dataset.chapterId;
    }));

    function currentTrack() {
      return tracks[activeIndex];
    }

    function setButtonState() {
      tracks.forEach(function (track, index) {
        const isActive = index === activeIndex;
        track.classList.toggle("is-active", isActive);
        if (isActive && typeof track.setAttribute === "function") {
          track.setAttribute("aria-current", "true");
        } else if (!isActive && typeof track.removeAttribute === "function") {
          track.removeAttribute("aria-current");
        }
      });
      if (previousButton) {
        previousButton.disabled = activeIndex === 0;
      }
      if (nextButton) {
        nextButton.disabled = activeIndex >= tracks.length - 1;
      }
      if (playToggle) {
        playToggle.textContent = audio.paused ? "Play" : "Pause";
      }
    }

    function updateProgress() {
      updateText(activeProgress, formatClock(audio.currentTime));
      if (activeDuration) {
        activeDuration.textContent = currentTrack().dataset.chapterDuration || formatClock(audio.duration);
      }
    }

    function applyTrack(index, options) {
      const settings = options || {};
      const track = tracks[index];
      if (!track) {
        return;
      }

      const wasPlaying = !audio.paused;
      if (wasPlaying && !settings.initialize) {
        audio.pause();
      }

      activeIndex = index;
      audio.dataset.audiobookId = track.dataset.audiobookId;
      audio.dataset.chapterId = track.dataset.chapterId;
      if (source) {
        source.setAttribute("src", track.dataset.chapterSrc);
        source.setAttribute("type", track.dataset.chapterMimeType);
      }
      if (typeof audio.load === "function") {
        audio.load();
      }

      updateText(activeLabel, track.dataset.chapterLabel);
      updateText(activeTitle, track.dataset.chapterTitle);
      updateText(activeSummary, track.dataset.chapterSummary);

      if (settings.reset) {
        clearPositionForIds(track.dataset.audiobookId, track.dataset.chapterId);
        setAudioTime(audio, 0);
      } else {
        restorePosition(audio);
      }

      updateProgress();
      setButtonState();

      if (!settings.initialize && (settings.play || wasPlaying)) {
        playAudio(audio);
      }
    }

    tracks.forEach(function (track, index) {
      track.addEventListener("click", function () {
        applyTrack(index);
      });
    });

    if (playToggle) {
      playToggle.addEventListener("click", function () {
        if (audio.paused) {
          playAudio(audio);
        } else {
          audio.pause();
        }
      });
    }

    seekButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        const delta = Number(button.dataset.audiobookSeek);
        if (!Number.isFinite(delta)) {
          return;
        }
        const nextTime = Math.max(0, audio.currentTime + delta);
        setAudioTime(audio, nextTime);
        storePosition(audio);
        updateProgress();
      });
    });

    if (previousButton) {
      previousButton.addEventListener("click", function () {
        applyTrack(activeIndex - 1);
      });
    }

    if (nextButton) {
      nextButton.addEventListener("click", function () {
        applyTrack(activeIndex + 1);
      });
    }

    audio.addEventListener("loadedmetadata", function () {
      restorePosition(audio);
      updateProgress();
    });
    audio.addEventListener("play", setButtonState);
    audio.addEventListener("pause", function () {
      storePosition(audio);
      setButtonState();
    });
    audio.addEventListener("timeupdate", function () {
      storePosition(audio);
      updateProgress();
    });
    audio.addEventListener("ended", function () {
      clearPosition(audio);
      if (activeIndex < tracks.length - 1) {
        applyTrack(activeIndex + 1, { play: true, reset: true });
      }
    });

    applyTrack(activeIndex, { initialize: true });
  }

  function wireLegacyAudioList() {
    const audios = queryAll(document, legacyAudioSelector);

    function pauseOtherAudio(currentAudio) {
      audios.forEach(function (audio) {
        if (audio !== currentAudio && !audio.paused) {
          audio.pause();
        }
      });
    }

    function playNextAudio(currentAudio) {
      const index = audios.indexOf(currentAudio);
      if (index === -1 || index >= audios.length - 1) {
        return;
      }

      const nextAudio = audios[index + 1];
      clearPosition(nextAudio);
      setAudioTime(nextAudio, 0);
      playAudio(nextAudio);
    }

    function wireAudio(audio) {
      audio.addEventListener("loadedmetadata", function () {
        restorePosition(audio);
      });
      audio.addEventListener("play", function () {
        pauseOtherAudio(audio);
      });
      audio.addEventListener("timeupdate", function () {
        storePosition(audio);
      });
      audio.addEventListener("pause", function () {
        storePosition(audio);
      });
      audio.addEventListener("ended", function () {
        storePosition(audio);
        playNextAudio(audio);
      });
      if (audio.readyState > 0) {
        restorePosition(audio);
      }
    }

    audios.forEach(wireAudio);
  }

  function copyText(value) {
    if (!value || !navigator.clipboard || typeof navigator.clipboard.writeText !== "function") {
      return null;
    }
    return navigator.clipboard.writeText(value);
  }

  function wireCopyAction(element) {
    element.addEventListener("click", function (event) {
      const value = element.dataset.copyValue || element.dataset.feedUrl;
      const copiedText = element.dataset.audioAssistCopied || "Copied Link";
      const feedback = element.querySelector("[data-audio-assist-feedback]");
      const writeAttempt = copyText(value);
      if (!writeAttempt) {
        return;
      }
      event.preventDefault();
      writeAttempt.then(function () {
        if (feedback) {
          feedback.textContent = copiedText;
        } else {
          element.textContent = copiedText;
        }
        window.setTimeout(function () {
          if (feedback) {
            feedback.textContent = "";
          }
        }, 1600);
      }).catch(function () {
        if (feedback) {
          feedback.textContent = "";
        }
      });
    });
  }

  function wireCopyActions() {
    const copyTargets = queryAll(document, "[data-audio-assist-copy][data-copy-value]");
    copyTargets.forEach(wireCopyAction);

    const legacyCopyTargets = queryAll(document, "[data-feed-copy][data-feed-url]");
    legacyCopyTargets.forEach(function (button) {
      button.dataset.copyValue = button.dataset.feedUrl;
      button.dataset.audioAssistCopied = "Copied Podcast Feed Link";
      wireCopyAction(button);
    });
  }

  function platformFamily() {
    const userAgent = `${navigator.userAgent || ""} ${navigator.platform || ""}`;
    if (/iPad|iPhone|iPod/.test(userAgent) || (/Macintosh/.test(userAgent) && navigator.maxTouchPoints > 1)) {
      return "ios";
    }
    if (/Android/.test(userAgent)) {
      return "android";
    }
    return "generic";
  }

  function wireHomescreenInstructions() {
    const instructions = queryAll(document, "[data-homescreen-instruction]");
    if (instructions.length === 0) {
      return;
    }
    const selected = platformFamily();
    instructions.forEach(function (instruction) {
      instruction.hidden = instruction.dataset.homescreenInstruction !== selected;
    });
  }

  function wireWebShare() {
    const shareButtons = queryAll(document, "[data-audio-web-share]");
    shareButtons.forEach(function (button) {
      if (!navigator.share) {
        return;
      }
      button.hidden = false;
      button.addEventListener("click", function () {
        const shareAttempt = navigator.share({
          title: button.dataset.shareTitle || document.title,
          url: button.dataset.shareUrl || window.location.href
        });
        if (shareAttempt && typeof shareAttempt.catch === "function") {
          shareAttempt.catch(function () {});
        }
      });
    });
  }

  const players = queryAll(document, ".audiobook-player");
  if (players.length > 0) {
    players.forEach(wireUnifiedPlayer);
  } else {
    wireLegacyAudioList();
  }
  wireCopyActions();
  wireHomescreenInstructions();
  wireWebShare();
})();
