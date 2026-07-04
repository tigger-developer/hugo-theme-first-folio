// ABOUTME: Persists audiobook chapter playback positions in browser localStorage.
// ABOUTME: Restores positions and advances through First Folio audiobook audio controls.
(function () {
  const storagePrefix = "first-folio:audiobook";
  const audioSelector = "audio[data-audiobook-id][data-chapter-id]";
  const audios = Array.from(document.querySelectorAll(audioSelector));

  function storageKey(audio) {
    const bookId = audio.dataset.audiobookId;
    const chapterId = audio.dataset.chapterId;
    if (!bookId || !chapterId) {
      return null;
    }
    return `${storagePrefix}:${bookId}:${chapterId}`;
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

  function restorePosition(audio) {
    const key = storageKey(audio);
    if (!key) {
      return;
    }
    const position = storedPosition(key);
    if (position === null) {
      return;
    }
    audio.currentTime = position;
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
    const playAttempt = nextAudio.play();
    if (playAttempt && typeof playAttempt.catch === "function") {
      playAttempt.catch(function () {
        // Browsers may block automatic playback; native controls remain usable.
      });
    }
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
})();
