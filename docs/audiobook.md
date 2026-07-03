# Audiobook Pages and Podcast Feeds

First Folio provides a theme-owned audiobook layout for sites that publish static audio chapters. Consuming sites provide content, metadata, and audio assets; the theme renders the page, podcast feed, and local listening-position behaviour.

## Minimal Frontmatter

Use `type: audiobook` and request both HTML and podcast output when a feed is needed:

```yaml
---
title: First Folio Demo Podcast
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
    chapters:
      - id: episode-1
        title: Demo Episode 1
        src: /audio/audiobook-demo/episode-1.m4a
        mimeType: audio/mp4
        byteLength: 64280
        episode: 1
---
```

The theme owns `layouts/audiobook/single.html` and `layouts/audiobook/single.podcast.xml`. Consuming sites should not copy those templates for normal use.

## Required Metadata

Required metadata is validated before the page or feed is published.

Book metadata:

- `id`: stable storage/feed identifier.
- `title`: podcast channel and page title.
- `description`: podcast channel description.
- `language`: feed language, such as `en-GB`.
- `explicit`: boolean podcast explicit-status metadata.
- `type`: optional podcast ordering type, either `serial` or `episodic`. Defaults to `serial` for audiobook-style sequential playback.
- `chapters`: one or more chapter objects.

Chapter metadata:

- `id`: stable chapter identifier. Values must be unique within the book.
- `title`: rendered chapter title and feed item title.
- `src`: audio URL or site-root-relative path.
- `mimeType`: enclosure MIME type, such as `audio/mp4`.
- `byteLength`: enclosure byte length in bytes.

## Optional Metadata

Optional metadata can enrich the feed without changing the required interface.

Book metadata may include `author` and `image`. Chapter metadata may include `summary`, `date`, `duration`, and `episode`.

Feed items are emitted in the same order as the configured `chapters` list. The theme does not sort chapters by date or episode number. Use `type: serial` for audiobook-style feeds that should be presented from first episode to last. Use `type: episodic` only for podcast-style feeds where clients should treat newer episodes as primary.

## Output Configuration

The example site declares a `podcast` output format with `baseName: feed`, so an audiobook page at `/audiobook-demo/` publishes `/audiobook-demo/feed.xml`.

```yaml
mediaTypes:
  application/rss+xml:
    suffixes:
      - xml
outputFormats:
  podcast:
    mediaType: application/rss+xml
    baseName: feed
    isPlainText: false
    noUgly: true
```

## Demo Audio Assets

The example site uses small `.m4a` demo files copied into the repository under `exampleSite/static/audio/audiobook-demo/`. Consuming projects should copy or publish their own audio files into their site and point chapter `src` values at those published URLs.

## Local Player Behaviour

The audiobook player script stores listening position in `localStorage` using stable `book id + chapter id` keys. When a visitor returns in the same browser, matching audio controls restore their previous position. Invalid or missing stored values are ignored so audio controls continue to load normally.

## Robots Metadata

Robots metadata is advisory. `robots: noindex,nofollow,noarchive` emits a matching `<meta name="robots">` tag, but consuming sites own `robots.txt`, private paths, and access control.
