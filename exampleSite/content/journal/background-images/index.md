---
title: "The Background Image Layout"
date: 2025-03-20
description: "Demonstrating the background layout, which places an atmospheric image behind the article content."
tags:
  - theme
  - layouts
  - reference
layout: background
image:
  src: background.jpg
  alt: "An atmospheric scene"
  caption: "Be Careful What You Wish For"
---

The `background` layout places the article's image behind the content, with configurable opacity and blur. The text remains fully readable while the image provides atmosphere.

## Controlling the Effect

Two parameters fine-tune the background:

- **`opacity`** — how visible the image is (0.0 to 1.0). Lower values are more subtle.
- **`blur`** — how much the image is blurred. Higher values create a softer, less distracting backdrop.

This page uses `opacity: 0.15` and `blur: 8px` for a gentle wash of colour behind the text.

## Site-Wide Defaults

You can set default values in `hugo.yaml`:

```yaml
params:
  bgImage:
    opacity: 0.2
    blur: 5px
```

Individual pages override these defaults via the `image` frontmatter block.

## Dark Mode

Background-image pages use the theme's dark canvas regardless of the visitor's light or dark preference. A consistent canvas makes the configured image opacity, wash, and text contrast predictable.

{{< callout type="tip" text="For background images, choose photographs with even tonal distribution. High-contrast images with bright spots can make overlaid text hard to read." >}}

## Spoilers Over Images

Inline spoilers retain their concealed treatment over an image-backed canvas: the photograph was taken {{< spoiler "after the storm had already passed" />}}.

{{< spoiler label="Background-layout detail" >}}
Block spoilers use the same dark-canvas contrast and reveal behaviour as the compact inline form.
{{< /spoiler >}}
