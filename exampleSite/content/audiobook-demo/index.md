---
title: First Folio Demo Audiobook
linkTitle: Audiobook Demo
type: audiobook
layout: hero
sectionLabel: Audiobook
description: A theme-owned audiobook page for sequential chapter playback, generated media metadata, and a serial RSS feed.
pin: 46
image:
  src: audiobook.jpg
  alt: "Open book with headphones and an audio player on a wooden desk"
  card_src: audiobook.jpg
  card_position: center center
outputs:
  - html
  - podcast
robots: noindex,nofollow,noarchive
params:
  audiobook:
    id: first-folio-demo-audiobook
    title: First Folio Demo Audiobook
    description: A short synthetic audiobook used by the First Folio example site.
    language: en-GB
    explicit: false
    type: serial
    author: First Folio
    image: /audiobook-demo/audiobook.jpg
    chapters:
      - id: chapter-1
        title: Demo Chapter 1
        src: /audio/audiobook-demo/episode-1.m4a
        mimeType: audio/mp4
        byteLength: 64280
        duration: "00:00:09"
        summary: A tiny demo chapter served from the example site's static audiobook directory.
      - id: chapter-2
        title: Demo Chapter 2
        src: /audio/audiobook-demo/episode-2.m4a
        mimeType: audio/mp4
        byteLength: 288535
        duration: "00:00:41"
        summary: A second demo chapter using the same theme-owned layout and feed template.
      - id: chapter-3
        title: Demo Chapter 3
        src: /audio/audiobook-demo/episode-3.m4a
        mimeType: audio/mp4
        byteLength: 778800
        duration: "00:01:50"
        summary: A third demo chapter for end-to-end page and podcast feed coverage.
---

This page demonstrates First Folio's theme-owned audio layout for audiobook-style sequential chapter playback. It uses the same reusable layout and RSS template as the podcast demo, but the front matter describes the work as a serial audiobook rather than an episodic show.

Expected audiobook behaviour:

- Feed type is `serial`, so clients should preserve the configured chapter order.
- The page chooses the existing `hero` visual layout, so the cover image is rendered by the standard page template before the audio controls.
- Items are labelled as chapters in the page content and omit podcast episode numbers.
- The page is promoted as a masonry card with `pin`, not as a carousel item.
- Listening position is stored per book id and chapter id in the browser.
- Generated media metadata supplies duration and byte length, while front matter remains the source of titles, summaries, and source URLs.

Use this pattern for audiobooks, serialized essays, course modules, or any audio work where the listener is expected to start at the beginning and continue in order.
