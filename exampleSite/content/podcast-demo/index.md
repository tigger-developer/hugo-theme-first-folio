---
title: First Folio Demo Podcast
linkTitle: Podcast Demo
type: audiobook
layout: audio
sectionLabel: Podcast
description: A theme-owned podcast page with episodic feed metadata, generated media facts, and demo audio files.
carousel: 4
image:
  src: podcast.jpg
  alt: "Podcast microphone and headphones on a wooden desk"
  card_src: podcast.jpg
  card_position: center center
  carousel_src: podcast.jpg
  carousel_position: center center
outputs:
  - html
  - podcast
  - webmanifest
robots: noindex,nofollow,noarchive
params:
  audiobook:
    id: first-folio-demo-podcast
    title: First Folio Demo Podcast
    description: A short synthetic podcast used by the First Folio example site.
    language: en-GB
    explicit: false
    type: episodic
    author: First Folio
    image: /podcast-demo/podcast.jpg
    chapters:
      - id: episode-1
        title: Demo Episode 1
        src: /audio/podcast-demo/episode-1.m4a
        mimeType: audio/mp4
        byteLength: 64280
        duration: "00:00:09"
        episode: 1
        summary: A tiny demo episode served from the example site's static audio directory.
      - id: episode-2
        title: Demo Episode 2
        src: /audio/podcast-demo/episode-2.m4a
        mimeType: audio/mp4
        byteLength: 288535
        duration: "00:00:41"
        episode: 2
        summary: A second demo episode using the same theme-owned layout and feed template.
      - id: episode-3
        title: Demo Episode 3
        src: /audio/podcast-demo/episode-3.m4a
        mimeType: audio/mp4
        byteLength: 778800
        duration: "00:01:50"
        episode: 3
        summary: A third demo episode for end-to-end page and podcast feed coverage.
---

This page demonstrates First Folio's theme-owned audio layout for podcast-style episodic publishing. It uses the same reusable layout and RSS template as the audiobook demo, but the front matter describes the work as a podcast rather than a sequential book.

Expected podcast behaviour:

- Feed type is `episodic`, so podcast clients may emphasize newer or featured episodes and fallback dates are not staggered by chapter order.
- The page chooses `layout: audio`, so the player is the primary hero-area experience. Because the page also has a background image, the theme follows the background-image convention and renders the page in a forced dark context.
- Items include `episode` numbers in front matter and RSS output.
- The page is promoted to the homepage carousel with `carousel`.
- Each episode has its own audio enclosure, duration, byte length, and summary.
- Generated media metadata supplies duration and byte length, while front matter remains the source of titles, summaries, episode numbers, and source URLs.

Use this pattern for radio-style shows, interviews, release notes, lectures, or any audio series where episodes can stand on their own.
