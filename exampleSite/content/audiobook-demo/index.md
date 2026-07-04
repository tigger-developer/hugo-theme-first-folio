---
title: First Folio Demo Audiobook
linkTitle: Audiobook Demo
type: audiobook
layout: background
author: "Taḋg Paul"
sectionLabel: Audiobook
description: A theme-owned audiobook page for sequential chapter playback, generated media metadata, and a serial RSS feed.
pin: 46
carousel: 5
image:
  src: beacon3.jpg
  alt: "Beacon light against a dark sky"
  card_src: beacon3.jpg
  card_position: center center
  carousel_src: beacon3.jpg
  carousel_position: center center
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
    image: /audiobook-demo/beacon3.jpg
    chapters:
      - id: front-matter
        title: Front Matter
        src: /audio/audiobook-demo/chapter00.m4a
        mimeType: audio/mp4
        summary: Opening material served from the example site's static audiobook directory.
      - id: chapter-1
        title: Demo Chapter 1
        src: /audio/audiobook-demo/chapter01.m4a
        mimeType: audio/mp4
        summary: The first audiobook chapter uses media that is distinct from the podcast demo.
      - id: chapter-2
        title: Demo Chapter 2
        src: /audio/audiobook-demo/chapter02.m4a
        mimeType: audio/mp4
        summary: A second demo chapter using the shared audio controls and feed template.
      - id: chapter-3
        title: Demo Chapter 3
        src: /audio/audiobook-demo/chapter03.m4a
        mimeType: audio/mp4
        summary: A third demo chapter for end-to-end page and podcast feed coverage.
      - id: chapter-4
        title: Demo Chapter 4
        src: /audio/audiobook-demo/chapter04.m4a
        mimeType: audio/mp4
        summary: A fourth demo chapter keeps the audiobook feed clearly separate from the podcast feed.
      - id: chapter-5
        title: Demo Chapter 5
        src: /audio/audiobook-demo/chapter05.m4a
        mimeType: audio/mp4
        summary: A fifth demo chapter exercises the serial feed order with additional entries.
      - id: chapter-6
        title: Demo Chapter 6
        src: /audio/audiobook-demo/chapter06.m4a
        mimeType: audio/mp4
        summary: A sixth demo chapter completes the separate audiobook media set.
---

This page demonstrates First Folio's theme-owned audio layout for audiobook-style sequential chapter playback. It uses the same reusable layout and RSS template as the podcast demo, but the front matter describes the work as a serial audiobook rather than an episodic show.

Expected audiobook behaviour:

- Feed type is `serial`, so clients should preserve the configured chapter order.
- The page chooses the existing `background` visual layout, so the cover image is rendered by the standard page template before the audio controls.
- Items are labelled as front matter and chapters in the page content and omit podcast episode numbers.
- The page is promoted to the homepage carousel with `carousel`, using the same front matter contract as other featured content.
- Listening position is stored per book id and chapter id in the browser.
- Generated media metadata supplies duration and byte length, while front matter remains the source of titles, summaries, and source URLs.

Use this pattern for audiobooks, serialized essays, course modules, or any audio work where the listener is expected to start at the beginning and continue in order.
