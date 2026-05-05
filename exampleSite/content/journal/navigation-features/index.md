---
title: "Navigation and CTA Features"
date: 2025-11-15
description: "Demonstrating breadcrumb trails, signpost CTAs, and table of contents."
tags:
  - theme
  - navigation
  - reference
author: "Theme Demo"
layout: hero
image:
  src: hero.jpg
  alt: "Navigation features demo"
toc: "Navigation features"
signpost:
  text: "THEME DOCUMENTATION"
  url: "https://github.com/tadg-paul/hugo-theme-first-folio"
signpost_footer:
  text: "VIEW ON GITHUB"
  url: "https://github.com/tadg-paul/hugo-theme-first-folio"
---

This page demonstrates the navigation features of the First Folio theme.

## Breadcrumb Trail

The breadcrumb trail appears automatically on article pages, showing the section path, author, and date. It uses purple accents for sections and orange for metadata.

Control it with frontmatter:

- `breadcrumb: false` — hide on article pages (default: true)
- `breadcrumb_list: true` — show on list/section pages (default: false)
- `hideAuthor: true` — omit author segment
- `hideDate: true` — omit date segment

## Signpost CTA

The signpost bar appears below the banner/hero image. Configure it in frontmatter:

```yaml
signpost:
  text: "AVAILABLE NOW"
  url: "https://example.com"
```

## Signpost Footer

A second CTA appears above footnotes and tags. It uses the same styling as the header signpost:

```yaml
signpost_footer:
  text: "BUY NOW"
  url: "https://example.com"
```

Both signpost and signpost_footer can be cascaded via `_index.md` frontmatter to apply across an entire section.

## Table of Contents

Set `toc: true` for a sticky sidebar TOC on desktop and a collapsible TOC on mobile. Set `toc` to a string to customise the heading:

```yaml
toc: "In this guide"
```

## Related Articles

Related articles appear automatically in the sidebar alongside the TOC on desktop, and below the content on mobile.
