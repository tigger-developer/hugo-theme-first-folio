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

  function scopedStorageKey(bookId, name) {
    if (!bookId || !name) {
      return null;
    }
    return `${storagePrefix}:${bookId}:${name}`;
  }

  function safeGetStorage(key) {
    if (!key) {
      return null;
    }
    try {
      return localStorage.getItem(key);
    } catch (_error) {
      return null;
    }
  }

  function safeSetStorage(key, value) {
    if (!key) {
      return;
    }
    try {
      localStorage.setItem(key, String(value));
    } catch (_error) {
      // Storage can be unavailable in private modes; audio controls should still work.
    }
  }

  function safeRemoveStorage(key) {
    if (!key) {
      return;
    }
    try {
      localStorage.removeItem(key);
    } catch (_error) {
      // Storage can be unavailable in private modes; audio controls should still work.
    }
  }

  function storedPosition(key) {
    const raw = safeGetStorage(key);
    const value = Number(raw);
    if (!Number.isFinite(value) || value <= 0) {
      return null;
    }
    return value;
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
    safeSetStorage(key, Math.floor(audio.currentTime));
  }

  function clearPositionForIds(bookId, chapterId) {
    const key = storageKeyForIds(bookId, chapterId);
    if (!key) {
      return;
    }
    safeRemoveStorage(key);
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

  function setHidden(element, hidden) {
    if (!element) {
      return;
    }
    if ("hidden" in element) {
      element.hidden = hidden;
    } else if (hidden && typeof element.setAttribute === "function") {
      element.setAttribute("hidden", "");
    } else if (!hidden && typeof element.removeAttribute === "function") {
      element.removeAttribute("hidden");
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
    const scrubber = queryOne(player, "[data-audiobook-scrubber]");
    const playIcon = queryOne(player, "[data-audiobook-play-icon]");
    const playLabel = queryOne(player, "[data-audiobook-play-label]");
    const feedback = queryOne(player, "[data-audiobook-feedback]");
    const errorMessage = queryOne(player, "[data-audiobook-error]");
    const upNext = queryOne(player, "[data-audiobook-up-next]");
    const resumeWork = queryOne(player, "[data-audiobook-resume-work]");
    const speedToggle = queryOne(player, "[data-audiobook-speed-toggle]");
    const speedMenu = queryOne(player, "[data-audiobook-speed-menu]");
    const speedStatus = queryOne(player, "[data-audiobook-speed-status]");
    const speedButtons = queryAll(player, "[data-audiobook-speed]");
    const sleepToggle = queryOne(player, "[data-audiobook-sleep-toggle]");
    const sleepMenu = queryOne(player, "[data-audiobook-sleep-menu]");
    const sleepStatus = queryOne(player, "[data-audiobook-sleep-status]");
    const sleepMinuteButtons = queryAll(player, "[data-audiobook-sleep-minutes]");
    const sleepEndButton = queryOne(player, "[data-audiobook-sleep-end]");
    const sleepCancelButton = queryOne(player, "[data-audiobook-sleep-cancel]");
    const startButtons = queryAll(player, "[data-audiobook-track-start]");
    const completeButtons = queryAll(player, "[data-audiobook-track-complete]");
    const queueUpButtons = queryAll(player, "[data-audiobook-queue-up]");
    const queueDownButtons = queryAll(player, "[data-audiobook-queue-down]");
    const queueResetButton = queryOne(player, "[data-audiobook-queue-reset]");

    if (!audio || tracks.length === 0) {
      return;
    }

    const bookId = audio.dataset.audiobookId || player.dataset.audiobookId;
    const speedKey = scopedStorageKey(bookId, "speed");
    const queueKey = scopedStorageKey(bookId, "queue");
    const canonicalOrder = tracks.map(function (track) {
      return track.dataset.chapterId;
    });
    let queueOrder = loadQueueOrder();
    let sleepTimer = null;
    let sleepMode = "";
    let activeIndex = Math.max(0, tracks.findIndex(function (track) {
      return track.dataset.chapterId === audio.dataset.chapterId;
    }));

    function trackById(chapterId) {
      return tracks.find(function (track) {
        return track.dataset.chapterId === chapterId;
      }) || null;
    }

    function trackIndexById(chapterId) {
      return tracks.findIndex(function (track) {
        return track.dataset.chapterId === chapterId;
      });
    }

    function activeTrackId() {
      const track = currentTrack();
      return track ? track.dataset.chapterId : "";
    }

    function loadQueueOrder() {
      const raw = safeGetStorage(queueKey);
      if (!raw) {
        return canonicalOrder.slice();
      }
      try {
        const parsed = JSON.parse(raw);
        if (!Array.isArray(parsed)) {
          return canonicalOrder.slice();
        }
        const known = parsed.filter(function (chapterId) {
          return canonicalOrder.indexOf(chapterId) !== -1;
        });
        canonicalOrder.forEach(function (chapterId) {
          if (known.indexOf(chapterId) === -1) {
            known.push(chapterId);
          }
        });
        return known;
      } catch (_error) {
        return canonicalOrder.slice();
      }
    }

    function storeQueueOrder() {
      safeSetStorage(queueKey, JSON.stringify(queueOrder));
    }

    function currentTrack() {
      return tracks[activeIndex];
    }

    function showFeedback(message) {
      updateText(feedback, message);
      if (!message || !globalThis.window || typeof window.setTimeout !== "function") {
        return;
      }
      window.setTimeout(function () {
        if (feedback && feedback.textContent === message) {
          updateText(feedback, "");
        }
      }, 1400);
    }

    function setDisclosure(toggle, menu, open) {
      setHidden(menu, !open);
      if (toggle && typeof toggle.setAttribute === "function") {
        toggle.setAttribute("aria-expanded", open ? "true" : "false");
      }
    }

    function closeDisclosures() {
      setDisclosure(speedToggle, speedMenu, false);
      setDisclosure(sleepToggle, sleepMenu, false);
    }

    function toggleDisclosure(toggle, menu, otherToggle, otherMenu) {
      const isOpen = menu ? !menu.hidden : false;
      setDisclosure(otherToggle, otherMenu, false);
      setDisclosure(toggle, menu, !isOpen);
    }

    function labelFor(track) {
      if (!track) {
        return "";
      }
      return `${track.dataset.chapterLabel || ""}: ${track.dataset.chapterTitle || ""}`.replace(/^: /, "").replace(/: $/, "");
    }

    function formatHumanTime(seconds) {
      const clock = formatClock(seconds);
      if (clock.indexOf(":") === -1) {
        return clock;
      }
      return clock.replace(/^00:/, "");
    }

    function completionKey(track) {
      if (!track) {
        return null;
      }
      return scopedStorageKey(track.dataset.audiobookId, `complete:${track.dataset.chapterId}`);
    }

    function updateStoredPositionAffordances() {
      let firstResumeTrack = null;
      let firstResumePosition = null;
      tracks.forEach(function (track) {
        const position = storedPosition(storageKeyForIds(track.dataset.audiobookId, track.dataset.chapterId));
        const row = track.closest ? track.closest("[data-audiobook-track-row]") : null;
        const resumeLabel = row ? queryOne(row, "[data-audiobook-track-resume]") : null;
        if (position !== null) {
          if (!firstResumeTrack) {
            firstResumeTrack = track;
            firstResumePosition = position;
          }
          updateText(resumeLabel, `Resume from ${formatHumanTime(position)}`);
          setHidden(resumeLabel, false);
        } else {
          updateText(resumeLabel, "");
          setHidden(resumeLabel, true);
        }
      });
      if (firstResumeTrack && resumeWork) {
        resumeWork.dataset.chapterId = firstResumeTrack.dataset.chapterId;
        updateText(resumeWork, `Resume ${labelFor(firstResumeTrack)} at ${formatHumanTime(firstResumePosition)}`);
        setHidden(resumeWork, false);
      } else if (resumeWork) {
        updateText(resumeWork, "");
        setHidden(resumeWork, true);
      }
    }

    function nextTrackFromQueue() {
      const queueIndex = queueOrder.indexOf(activeTrackId());
      if (queueIndex === -1 || queueIndex >= queueOrder.length - 1) {
        return null;
      }
      return trackById(queueOrder[queueIndex + 1]);
    }

    function updateUpNext() {
      const nextTrack = nextTrackFromQueue();
      updateText(upNext, nextTrack ? `Up next: ${labelFor(nextTrack)}` : "Up next: end of list");
    }

    function setError(message) {
      updateText(errorMessage, message);
      setHidden(errorMessage, !message);
    }

    function updateMediaSession() {
      if (typeof navigator === "undefined" || !navigator.mediaSession) {
        return;
      }
      const track = currentTrack();
      const metadata = {
        title: labelFor(track),
        artist: player.dataset.audiobookAuthor || "",
        album: player.dataset.audiobookTitle || ""
      };
      if (player.dataset.audiobookArtwork) {
        metadata.artwork = [{ src: player.dataset.audiobookArtwork }];
      }
      if (typeof MediaMetadata === "function") {
        navigator.mediaSession.metadata = new MediaMetadata(metadata);
      } else {
        navigator.mediaSession.metadata = metadata;
      }
    }

    function registerMediaSessionActions() {
      if (typeof navigator === "undefined" || !navigator.mediaSession || typeof navigator.mediaSession.setActionHandler !== "function") {
        return;
      }
      const actions = {
        play: function () { playAudio(audio); },
        pause: function () { audio.pause(); },
        seekbackward: function () { seekBy(-30); },
        seekforward: function () { seekBy(15); },
        previoustrack: function () { applyTrack(activeIndex - 1); },
        nexttrack: function () {
          const nextTrack = nextTrackFromQueue();
          if (nextTrack) {
            applyTrack(trackIndexById(nextTrack.dataset.chapterId));
          }
        }
      };
      Object.keys(actions).forEach(function (action) {
        try {
          navigator.mediaSession.setActionHandler(action, actions[action]);
        } catch (_error) {
          // Some browsers expose only part of the action set.
        }
      });
    }

    function setButtonState() {
      tracks.forEach(function (track, index) {
        const isActive = index === activeIndex;
        track.classList.toggle("is-active", isActive);
        const row = track.closest ? track.closest("[data-audiobook-track-row]") : null;
        if (row) {
          row.classList.toggle("is-active", isActive);
        }
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
        const label = audio.paused ? "Play" : "Pause";
        if (playIcon) {
          playIcon.classList.toggle("audiobook-icon-play", audio.paused);
          playIcon.classList.toggle("audiobook-icon-pause", !audio.paused);
        }
        updateText(playLabel, label);
        if (typeof playToggle.setAttribute === "function") {
          playToggle.setAttribute("aria-label", label);
        }
      }
      updateUpNext();
      updateMediaSession();
    }

    function updateProgress() {
      updateText(activeProgress, formatClock(audio.currentTime));
      if (activeDuration) {
        activeDuration.textContent = currentTrack().dataset.chapterDuration || formatClock(audio.duration);
      }
      if (scrubber) {
        if (Number.isFinite(audio.duration) && audio.duration > 0) {
          scrubber.max = String(Math.floor(audio.duration));
        }
        scrubber.value = String(Math.floor(audio.currentTime || 0));
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
      setHidden(activeLabel, !track.dataset.chapterLabel);
      updateText(activeTitle, track.dataset.chapterTitle);
      updateText(activeSummary, track.dataset.chapterSummary);
      setError("");

      if (settings.reset) {
        clearPositionForIds(track.dataset.audiobookId, track.dataset.chapterId);
        setAudioTime(audio, 0);
      } else {
        restorePosition(audio);
      }

      updateProgress();
      setButtonState();
      applySpeed(currentSpeed());
      updateStoredPositionAffordances();

      if (!settings.initialize && (settings.play || wasPlaying)) {
        playAudio(audio);
      }
    }

    function currentSpeed() {
      const stored = Number(safeGetStorage(speedKey));
      if (Number.isFinite(stored) && stored > 0) {
        return stored;
      }
      return 1;
    }

    function applySpeed(rate) {
      if (!Number.isFinite(rate) || rate <= 0) {
        return;
      }
      audio.playbackRate = rate;
      updateText(speedStatus, `${rate}x`);
      speedButtons.forEach(function (button) {
        const isActive = Number(button.dataset.audiobookSpeed) === rate;
        if (typeof button.setAttribute === "function") {
          button.setAttribute("aria-pressed", isActive ? "true" : "false");
        }
      });
    }

    function setSpeed(rate) {
      applySpeed(rate);
      safeSetStorage(speedKey, rate);
      closeDisclosures();
      showFeedback(`Speed ${rate}x`);
    }

    function seekBy(delta) {
      if (!Number.isFinite(delta)) {
        return;
      }
      const nextTime = Math.max(0, audio.currentTime + delta);
      setAudioTime(audio, nextTime);
      storePosition(audio);
      updateProgress();
      updateStoredPositionAffordances();
      showFeedback(delta < 0 ? `Back ${Math.abs(delta)} seconds` : `Forward ${delta} seconds`);
    }

    function clearSleepTimer() {
      if (sleepTimer && globalThis.window && typeof window.clearTimeout === "function") {
        window.clearTimeout(sleepTimer);
      }
      sleepTimer = null;
      sleepMode = "";
    }

    function setMinuteSleepTimer(minutes) {
      clearSleepTimer();
      if (!globalThis.window || typeof window.setTimeout !== "function") {
        return;
      }
      sleepMode = "minutes";
      updateText(sleepStatus, `${minutes} min`);
      closeDisclosures();
      showFeedback(`Sleep timer ${minutes} min`);
      sleepTimer = window.setTimeout(function () {
        storePosition(audio);
        audio.pause();
        clearSleepTimer();
        updateText(sleepStatus, "Off");
        showFeedback("Sleep timer ended");
      }, minutes * 60 * 1000);
    }

    function setEndOfItemSleepTimer() {
      clearSleepTimer();
      sleepMode = "end";
      updateText(sleepStatus, "End");
      closeDisclosures();
      showFeedback("Sleep at end of item");
    }

    function moveQueue(chapterId, delta) {
      const current = queueOrder.indexOf(chapterId);
      const next = current + delta;
      if (current === -1 || next < 0 || next >= queueOrder.length) {
        return;
      }
      const moved = queueOrder.splice(current, 1)[0];
      queueOrder.splice(next, 0, moved);
      storeQueueOrder();
      updateUpNext();
      showFeedback("Queue updated");
    }

    function restartTrack(chapterId) {
      const index = trackIndexById(chapterId);
      if (index === -1) {
        return;
      }
      applyTrack(index, { play: true, reset: true });
      showFeedback("Started from beginning");
    }

    function markComplete(chapterId) {
      const track = trackById(chapterId);
      if (!track) {
        return;
      }
      clearPositionForIds(track.dataset.audiobookId, track.dataset.chapterId);
      safeSetStorage(completionKey(track), "1");
      updateStoredPositionAffordances();
      showFeedback("Marked complete");
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
        seekBy(Number(button.dataset.audiobookSeek));
      });
    });

    speedButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        setSpeed(Number(button.dataset.audiobookSpeed));
      });
    });

    sleepMinuteButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        setMinuteSleepTimer(Number(button.dataset.audiobookSleepMinutes));
      });
    });

    if (speedToggle) {
      speedToggle.addEventListener("click", function () {
        toggleDisclosure(speedToggle, speedMenu, sleepToggle, sleepMenu);
      });
    }

    if (sleepToggle) {
      sleepToggle.addEventListener("click", function () {
        toggleDisclosure(sleepToggle, sleepMenu, speedToggle, speedMenu);
      });
    }

    if (sleepEndButton) {
      sleepEndButton.addEventListener("click", setEndOfItemSleepTimer);
    }

    if (sleepCancelButton) {
      sleepCancelButton.addEventListener("click", function () {
        clearSleepTimer();
        updateText(sleepStatus, "Off");
        closeDisclosures();
        showFeedback("Sleep timer cancelled");
      });
    }

    if (resumeWork) {
      resumeWork.addEventListener("click", function () {
        const index = trackIndexById(resumeWork.dataset.chapterId);
        if (index !== -1) {
          applyTrack(index, { play: true });
        }
      });
    }

    startButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        restartTrack(button.dataset.chapterId);
      });
    });

    completeButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        markComplete(button.dataset.chapterId);
      });
    });

    queueUpButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        moveQueue(button.dataset.chapterId, -1);
      });
    });

    queueDownButtons.forEach(function (button) {
      button.addEventListener("click", function () {
        moveQueue(button.dataset.chapterId, 1);
      });
    });

    if (queueResetButton) {
      queueResetButton.addEventListener("click", function () {
        queueOrder = canonicalOrder.slice();
        safeRemoveStorage(queueKey);
        updateUpNext();
        showFeedback("Queue reset");
      });
    }

    if (scrubber) {
      scrubber.addEventListener("input", function () {
        const nextTime = Number(scrubber.value);
        if (!Number.isFinite(nextTime)) {
          return;
        }
        setAudioTime(audio, nextTime);
        storePosition(audio);
        updateProgress();
      });
    }

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
      if (sleepMode === "end") {
        audio.pause();
        clearSleepTimer();
        updateText(sleepStatus, "Off");
        showFeedback("Sleep timer ended");
        return;
      }
      const nextTrack = nextTrackFromQueue();
      if (nextTrack) {
        applyTrack(trackIndexById(nextTrack.dataset.chapterId), { play: true, reset: true });
      }
    });
    audio.addEventListener("error", function () {
      setError(`Could not play ${labelFor(currentTrack())}. Try another item.`);
    });

    if (typeof document.addEventListener === "function") {
      document.addEventListener("keydown", function (event) {
        const target = event.target || {};
        const tagName = String(target.tagName || "").toLowerCase();
        if (tagName === "input" || tagName === "textarea" || tagName === "select" || target.isContentEditable) {
          return;
        }
        const key = event.key;
        if (key === " " || key === "p" || key === "P") {
          event.preventDefault();
          if (audio.paused) {
            playAudio(audio);
          } else {
            audio.pause();
          }
          showFeedback(audio.paused ? "Paused" : "Playing");
        } else if (key === "h" || key === "H" || key === "ArrowLeft") {
          event.preventDefault();
          seekBy(-30);
        } else if (key === "l" || key === "L" || key === "ArrowRight") {
          event.preventDefault();
          seekBy(15);
        } else if (key === "j" || key === "J" || key === "ArrowDown") {
          event.preventDefault();
          const nextTrack = nextTrackFromQueue();
          if (nextTrack) {
            applyTrack(trackIndexById(nextTrack.dataset.chapterId));
          }
          showFeedback("Next item");
        } else if (key === "k" || key === "K" || key === "ArrowUp") {
          event.preventDefault();
          applyTrack(activeIndex - 1);
          showFeedback("Previous item");
        } else if (key === "-" || key === "_" || key === "=" || key === "+") {
          event.preventDefault();
          const speeds = speedButtons.map(function (button) {
            return Number(button.dataset.audiobookSpeed);
          }).filter(function (rate) {
            return Number.isFinite(rate) && rate > 0;
          });
          const current = currentSpeed();
          const currentIndex = Math.max(0, speeds.indexOf(current));
          const delta = (key === "-" || key === "_") ? -1 : 1;
          const nextIndex = Math.min(speeds.length - 1, Math.max(0, currentIndex + delta));
          setSpeed(speeds[nextIndex] || current);
        }
      });
    }

    registerMediaSessionActions();
    applySpeed(currentSpeed());
    applyTrack(activeIndex, { initialize: true });
    updateStoredPositionAffordances();
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
    if (!value || typeof navigator === "undefined" || !navigator.clipboard || typeof navigator.clipboard.writeText !== "function") {
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
    if (typeof navigator === "undefined") {
      return "generic";
    }
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
      button.addEventListener("click", function () {
        if (!navigator.share) {
          const feedback = queryOne(button, "[data-audio-assist-feedback]");
          const writeAttempt = copyText(button.dataset.copyValue || button.dataset.shareUrl || window.location.href);
          if (!writeAttempt) {
            return;
          }
          writeAttempt.then(function () {
            if (feedback) {
              feedback.textContent = button.dataset.audioAssistCopied || "Copied Link";
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
          return;
        }
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

  function wireResponsiveAssistPanels() {
    if (!globalThis.window || !globalThis.window.matchMedia) {
      return;
    }
    const panels = queryAll(document, ".audiobook-sidebar details.audiobook-assist-panel");
    if (panels.length === 0) {
      return;
    }
    const media = window.matchMedia("(max-width: 55.99rem)");
    const syncPanels = function () {
      panels.forEach(function (panel) {
        if (media.matches) {
          panel.removeAttribute("open");
          return;
        }
        panel.setAttribute("open", "");
      });
    };
    syncPanels();
    if (typeof media.addEventListener === "function") {
      media.addEventListener("change", syncPanels);
    } else if (typeof media.addListener === "function") {
      media.addListener(syncPanels);
    }
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
  wireResponsiveAssistPanels();
})();
