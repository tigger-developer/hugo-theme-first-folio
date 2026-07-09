---
title: Label Fixture
type: audiobook
outputs:
  - html
  - podcast
params:
  audiobook:
    id: label-fixture
    title: Label Fixture
    description: Label fixture description.
    language: en-GB
    explicit: false
    type: serial
    itemTerm: Stanza
    itemTermPlural: Stanzas
    chapters:
      - id: part-one
        label: Part One
        title: PART ONE
        role: section
        src: /audio/part-one.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: stanza-1
        label: Stanza 1
        title: First Movement
        src: /audio/stanza-1.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: unlabelled-track
        title: Title Only Track
        src: /audio/title-only.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: labelled-track
        label: Track 8
        title: Explicit Label
        src: /audio/track-8.m4a
        mimeType: audio/mp4
        byteLength: 12345
---

Fixture body.
