<!-- Version: 1.4 | Last updated: 2026-07-09 -->

# Audiobook Pages and Podcast Feeds

First Folio provides theme-owned audio controls and podcast feeds for sites that publish static audio chapters. Consuming sites provide content, metadata, audio assets, and the normal First Folio visual layout choice; the theme renders the page, podcast feed, and local listening-position behaviour.

## Minimal Frontmatter

Use `type: audiobook` and request both HTML and podcast output when a feed is needed:

```yaml
---
title: First Folio Demo Audiobook
type: audiobook
layout: audio
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
    subscribe:
      label: Listen in your favourite podcast app
      prompt: Copy this Podcast Feed Link.
      hint: In your podcast app, look for Add Link or Add Feed, then paste it there.
      copied: Copied Podcast Feed Link
    chapters:
      - id: chapter-1
        title: Demo Chapter 1
        src: /audio/audiobook-demo/chapter01.m4a
        mimeType: audio/mp4
        byteLength: 64280
---
```

Use `layout: audio` for the theme-owned audio page experience. It places the web player in the hero position so audio is the primary interaction on the page. `layout: audio` requires `params.audiobook`.

The `type: audiobook` value selects the audio data contract and podcast feed template. The `params.audiobook.type` value selects feed ordering semantics and is separate from Hugo's page `type`. Audio pages may still choose another First Folio layout when a site needs an ordinary article presentation, but the recommended layout for podcast and audiobook pages is `layout: audio`.

When `layout: audio` is used with `image.src`, the image becomes the page canvas and the page follows the same dark-background convention as `layout: background`: the ambience toggle is hidden and the page is forced into the dark theme for predictable image opacity, wash, and text legibility.

The theme owns the audio controls and `layouts/audiobook/single.podcast.xml`. Consuming sites should not copy those templates or partials for normal use.

## Required Metadata

Required metadata is validated before the page or feed is published.

Book metadata:

- `id`: stable storage/feed identifier.
- `title`: podcast channel and page title.
- `description`: podcast channel description.
- `language`: feed language, such as `en-GB`.
- `explicit`: boolean podcast explicit-status metadata.
- `type`: optional podcast ordering type, either `serial` or `episodic`. Defaults to `episodic` for podcast-style feeds. Set `type: serial` for audiobook-style sequential playback.
- `chapters`: one or more chapter objects.

Chapter metadata:

- `id`: stable chapter identifier. Values must be unique within the book.
- `title`: rendered chapter title and feed item title.
- `src`: audio URL, site-root-relative path, or page-resource-relative path.
- `mimeType`: enclosure MIME type, such as `audio/mp4`.
- `byteLength`: enclosure byte length in bytes.

The `src` value supports these forms:

- Absolute URL, for media hosted outside the site: `https://media.example.com/book/chapter01.m4a`.
- Site-root-relative static path: `/audio/book/chapter01.m4a`.
- Page-resource-relative path inside the current page bundle: `chapter01.m4a` or `media/chapter01.m4a`.
- Page-resource-relative path into another bundle, such as `../shared-audio/chapter01.m4a`, when that path resolves to a Hugo page resource.

## Optional Metadata

Optional metadata can enrich the feed without changing the required interface.

Book metadata may include `author`, `image`, `subscribe`, `save`, and `homescreen`. Chapter metadata may include `summary`, `date`, `duration`, `episode`, and `label`. Feed item dates use the chapter front matter `date` when present, then generated media `date` when present, and otherwise fall back to the page date. For `serial` feeds only, page-date fallback is staggered by chapter index in one-second increments so clients that sort by date still receive a stable ordering hint. Explicit chapter dates and generated media dates are never adjusted by this rule. `episodic` feeds keep the unmodified page-date fallback because podcast episode dates normally represent publication chronology.

Feed items are emitted in the same order as the configured `chapters` list. The theme does not sort chapters by date or episode number. Use `type: serial` for audiobook-style feeds that should be presented from first episode to last. Omit `type` or use `type: episodic` for podcast-style feeds where clients should treat newer episodes as primary.

## Generated Media Metadata

Front matter remains the canonical source for editorial metadata and chapter `src` values. Sites may provide generated media facts in `data/first_folio_media.yaml`, keyed by audiobook/podcast id and item id:

```yaml
first-folio-demo-podcast:
  episode-1:
    src: /audio/podcast-demo/episode-1.m4a
    byteLength: 64280
    duration: "00:00:03"
    date: 2024-07-04T09:30:00+01:00
```

Generated data is optional and works for both local and remote media. It is the preferred contract for binary-derived facts when a site has a build step that can inspect or fetch media metadata. Manual front matter remains supported for existing sites, simple sites, and remote media hosts where Hugo cannot see the files.

The theme applies media facts in this order:

- `src`: front matter is canonical. A generated `src`, when present, must match front matter or the build fails as stale metadata.
- `date`: front matter, then generated data, then fallback. For `serial` feeds only, fallback dates are staggered by chapter index in one-second increments.
- `duration`: generated data, then front matter, then omitted.
- `byteLength`: generated data, then local file size via `os.Stat` for resolvable page resources or site-root-relative static files, then front matter, then a build error for podcast RSS.
- `mimeType`: front matter, then generated data, then a build error.

The theme does not run media probes. Consuming sites that want reproducible durations should generate data before Hugo runs, for example with `ffprobe`, a CMS export, or a host-specific metadata script. Build scripts should fail early when generated data is stale or required enclosure metadata cannot be resolved; the RSS template also fails the Hugo build for unresolved enclosure length or MIME type.

This repository demonstrates the generated-metadata pattern with separate podcast and audiobook example pages. Both demos use `layout: audio` with background images so the player is the primary page experience and the image canvas follows the dark-background convention. `make generate-audiobook-metadata` reads both demo content files and writes one combined `data/first_folio_media.yaml`; run it explicitly when demo audio files or chapter source paths change, then commit the updated YAML. The production exampleSite build is `HUGO_ENVIRONMENT=theme-demo-live make build`; `make build` deliberately requires the caller to provide `HUGO_ENVIRONMENT` and fails if the committed metadata file is missing. GitHub Pages deploys do not run `ffprobe`.

## Output Configuration

The example site declares a `podcast` output format with `baseName: feed`, so the podcast demo at `/podcast-demo/` publishes `/podcast-demo/feed.xml` and the audiobook demo at `/audiobook-demo/` publishes `/audiobook-demo/feed.xml`. It also declares a `webmanifest` output format with `baseName: manifest` so audio pages can publish `/manifest.webmanifest` for Home Screen metadata when that output is requested.

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
  webmanifest:
    mediaType: application/manifest+json
    baseName: manifest
    isPlainText: true
    noUgly: true
```

## Web Player and Sidebar Controls

Audio pages render a single web player for both audiobook and podcast modes. The page still models audio as chapters or episodes, but the visible player exposes only one play/pause control, back 30 seconds, forward 15 seconds, previous and next item controls, current item metadata, and a visible ordered list of tappable chapter or episode names. This keeps item granularity available for listeners who open the same private link in another browser context and lose local saved position.

The same UX is used for `serial` audiobooks and `episodic` podcasts. Differences are limited to labels, feed ordering semantics, and the content supplied by the page. `episodic` is the default and is intended for podcast-style feeds where episodes can stand alone. Set `type: serial` for chapter-order listening.

Secondary actions live in the audio sidebar and are expanded by default:

- `Save to your Home Screen`: shows a Web Share button only when the browser exposes `navigator.share`, followed by iOS, Android, or generic instructions. iOS-family browsers receive Share icon / Add to Home Screen guidance; Android-family browsers receive browser menu / Add to Home screen or Install app guidance.
- `Listen in your favourite podcast app`: contains the feed Link, copy glyph, short setup instructions, and copy feedback.

Default podcast-app setup does not render named app links because app-specific URL schemes overpromise behaviour that many players do not support. The default copy is deliberately manual and uses `Link` rather than `URL`:

```text
Copy this Podcast Feed Link.
In your podcast app, look for Add Link or Add Feed, then paste it there.
```

Clicking the feed panel copy target copies the absolute feed Link when clipboard access is available and displays `Copied Podcast Feed Link`. The visible feed Link remains selectable when clipboard access is unavailable.

The default visible text can be overridden per page without copying templates. Feed setup text lives under `params.audiobook.subscribe`; Home Screen guidance lives under `params.audiobook.homescreen`:

```yaml
params:
  audiobook:
    subscribe:
      label: Listen in an app
      prompt: Choose where to open this feed.
      hint: Paste this Link into the app's Add Feed screen.
      copied: Copied Podcast Feed Link
    homescreen:
      enabled: true
      label: Save to your Home Screen
      prompt: Use your browser's Share or menu button to add this page to your phone.
      ios: On iPhone or iPad, tap the browser Share button, then choose Add to Home Screen.
      android: On Android, open the browser menu, then choose Add to Home screen or Install app.
      fallback: Use your browser menu to bookmark this page or add it to your device home screen.
```

## Demo Audio Assets

The example site uses small `.m4a` demo files copied into the repository under `exampleSite/static/audio/podcast-demo/` and `exampleSite/static/audio/audiobook-demo/`. Consuming projects should copy or publish their own audio files into their site and point item `src` values at those published URLs.

## Local Player Behaviour

The audiobook player script stores listening position in `localStorage` using stable `book id + chapter id` keys. When a visitor returns in the same browser, the matching chapter or episode restores its previous position. When an item ends, the script clears any stale saved position for the next item, starts it from zero, and attempts to continue playback in page order. Browsers that block automatic playback leave the player controls usable. The page exposes one active audio element at a time, so starting another chapter or episode changes the active item instead of creating multiple competing play buttons. Invalid or missing stored values are ignored so audio controls continue to load normally.

## Changelog

- 1.1 (2026-07-09): Document the unified player, sidebar help panels, Home Screen guidance, webmanifest output, and override contract.

## Robots Metadata

Robots metadata is advisory. `robots: noindex,nofollow,noarchive` emits a matching `<meta name="robots">` tag, but consuming sites own `robots.txt`, private paths, and access control.
