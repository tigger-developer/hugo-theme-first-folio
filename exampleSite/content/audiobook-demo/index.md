---
title: First Folio Demo Podcast
linkTitle: Audiobook Demo
type: audiobook
outputs:
  - html
  - podcast
robots: noindex,nofollow,noarchive
params:
  audiobook:
    id: first-folio-demo-podcast
    title: First Folio Demo Podcast
    description: A short synthetic podcast used by the First Folio example site.
    language: en-GB
    explicit: false
    type: serial
    author: First Folio
    chapters:
      - id: episode-1
        title: Demo Episode 1
        src: /audio/audiobook-demo/episode-1.m4a
        mimeType: audio/mp4
        byteLength: 64280
        duration: "00:00:09"
        episode: 1
        summary: A tiny demo chapter served from the example site's static audio directory.
      - id: episode-2
        title: Demo Episode 2
        src: /audio/audiobook-demo/episode-2.m4a
        mimeType: audio/mp4
        byteLength: 288535
        duration: "00:00:41"
        episode: 2
        summary: A second demo chapter using the same theme-owned layout and feed template.
      - id: episode-3
        title: Demo Episode 3
        src: /audio/audiobook-demo/episode-3.m4a
        mimeType: audio/mp4
        byteLength: 778800
        duration: "00:01:50"
        episode: 3
        summary: A third demo chapter for end-to-end page and podcast feed coverage.
---

This page demonstrates First Folio's theme-owned audiobook layout. The page, controls, podcast feed, and listening-position behaviour all come from the theme; the consuming site provides only this content file and the copied demo audio files.
