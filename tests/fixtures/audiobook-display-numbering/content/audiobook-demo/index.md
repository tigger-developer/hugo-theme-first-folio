---
title: Display Numbering Fixture
type: audiobook
outputs:
  - html
  - podcast
params:
  audiobook:
    id: display-numbering-fixture
    title: Display Numbering Fixture
    description: Display numbering fixture description.
    language: en-GB
    explicit: false
    type: serial
    startNumber: 13
    chapters:
      - id: front-matter
        title: Front Matter
        src: /audio/front-matter.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: part-two
        title: Part Two
        role: part
        src: /audio/part-two.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: chapter-13
        title: Telling the Truth
        src: /audio/chapter-13.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: chapter-14
        title: Buttons
        src: /audio/chapter-14.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: appendix-a
        title: Appendix Note
        displayNumber: A
        src: /audio/appendix-a.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: manual-label
        label: Interlude
        title: Label Wins
        displayNumber: 99
        src: /audio/manual-label.m4a
        mimeType: audio/mp4
        byteLength: 12345
      - id: generated-label
        title: Generated Label Wins
        displayNumber: 100
        src: /audio/generated-label.m4a
        mimeType: audio/mp4
        byteLength: 12345
---

Fixture body.
