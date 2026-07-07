---
title: Relative Resource Audiobook
type: audiobook
outputs:
  - html
  - podcast
params:
  audiobook:
    id: relative-resource-audiobook
    title: Relative Resource Podcast
    description: Fixture podcast for relative page resources.
    language: en-GB
    explicit: false
    chapters:
      - id: same-bundle
        title: Same Bundle
        src: ch00.m4a
        mimeType: audio/mp4
      - id: dot-relative
        title: Dot Relative
        src: ./ch01.m4a
        mimeType: audio/mp4
      - id: nested-resource
        title: Nested Resource
        src: files/ch02.m4a
        mimeType: audio/mp4
      - id: sibling-resource
        title: Sibling Resource
        src: ../sibling-bundle/ch03.m4a
        mimeType: audio/mp4
---

Fixture audiobook body.
