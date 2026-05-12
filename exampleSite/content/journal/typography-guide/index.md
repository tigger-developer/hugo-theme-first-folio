---
title: "A Comprehensive Guide to Typography in the First Folio Theme"
linkTitle: "Typography"
date: 2025-07-01
description: "A demonstration of typography in the First Folio theme."
tags:
  - theme
  - typography
  - reference
layout: banner
image:
  src: banner.jpg
  alt: "Colourful paint splatter typography on black background"
  caption: "Jump for Joy"
toc: true
tldr: "A comprehensive demonstration of how standard Markdown elements render in this theme, alongside the custom shortcodes that extend it."
pin: 100
---

This post demonstrates how standard Markdown typography renders in the First Folio theme. Use it as a reference when writing content. Each section below shows a different element — read top to bottom for the full tour, or jump to a specific feature using the table of contents.

# Heading 1

Headings from H2 to H6 are available on demand. Header 1 is differentiated from the page title — prefixes can be configured or removed in the theme settings.

## Heading 2

Some paragraph text under a level-two heading. Most articles will use H2 as their top-level structural marker, with H3 and below for sub-sections.

### Heading 3

Standard **Markdown** elements are supported, along with a variety of custom shortcodes for images, galleries, callouts, and more.

#### Heading 4

`Orgmode` markup is also supported, with a wider range of elements available in that syntax. This allows for more complex formatting when needed, while still supporting the simplicity of Markdown for most use cases. You can use whichever syntax is best for each article.

##### Heading 5

A fifth-level heading is rare in body text but available when you need it.

###### Heading 6

The deepest level — useful for footnote-style sub-divisions.

## Text Formatting

Regular paragraph text flows naturally. **Bold text** for emphasis. *Italic text* for subtlety. ***Bold italic*** combines both. ~~Strikethrough~~ for corrections. `Inline code` for technical terms or short snippets. You can also use [hyperlinks](https://gohugo.io) inline.

For typographic embellishment, use the {{< colorbold "colorbold" >}} shortcode to highlight a phrase in the accent colour without underlining it.

> Blockquotes are useful for highlighting important passages or attributing quotes to their sources. They sit indented from the body text with a vertical accent line on the left.

For a more dramatic pull-quote, use the `quote` shortcode:

{{< quote attribution="Lao Tzu" >}}
A journey of a thousand miles begins with a single step.
{{< /quote >}}

## Lists

### Unordered

- First item
- Second item
  - Nested item
  - Another nested item with **bold** and *italic* text
- Third item

### Ordered

1. First step
2. Second step with a longer description that wraps onto multiple lines, demonstrating how list items handle reflowing text gracefully.
3. Third step
   1. Sub-step one
   2. Sub-step two

### Definition list

Term 1
: First definition. Lists like this are useful for glossaries or specification documents.

Term 2
: Second definition with **inline formatting** supported.

## Callouts

Callouts draw the reader's attention to important information using colour-coded boxes:

{{< callout type="info" text="This is an informational callout — useful for context and clarification." >}}

{{< callout type="tip" text="A tip callout shares helpful advice or shortcuts." >}}

{{< callout type="warning" text="Warnings flag potential pitfalls or edge cases." >}}

{{< callout type="alert" text="Alerts mark urgent or critical information." >}}

## Code Blocks

Syntax-highlighted code blocks for multiple languages:

```python
def greet(name: str) -> str:
    """Return a greeting for the given name."""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("world"))
```

```bash
#!/usr/bin/env bash
set -euo pipefail
echo "Hello from the shell"
```

```yaml
params:
  ambience:
    default: dark
    toggle: true
```

Inline `code spans` work too, of course.

## Tables

| Feature | Supported | Notes |
|---------|-----------|-------|
| Masonry grid | Yes | CSS Grid + JavaScript hybrid |
| Galleries | Yes | With lightbox and EXIF |
| Dark mode | Yes | Auto, toggle, or fixed |
| Sidebars | Yes | Four configuration modes |
| Shortcodes | Yes | 18+ built-in, custom welcome |

## Links and Images

[External link](https://gohugo.io) to the Hugo project. Internal links to other articles work the same way: [The Cartographer](/poetry/the-cartographer/).

{{< img src="typography-2.jpg" alt="Bold serif typography with paint splatter" caption="Display typography with painterly flourishes" position="right" width="40%" >}}

Inline images can be floated alongside text using the `img` shortcode. The image to the right shows display typography rendered with paint splatter effects — useful for hero images and editorial features. Captions sit below the image with optional blur and opacity controls.

{{< img src="typography-1.jpg" alt="Reproduction of a Gutenberg printing press" caption="A Gutenberg-style printing press, faithfully reproduced." position="left" width="40%" >}}

Images can also be floated to the left, with text wrapping on the right. The shortcode supports several positioning options (`left`, `right`, `center`), responsive width values, and optional links to make the image clickable. Hand-drawn illustrations sit naturally alongside body text without dominating the page.

Images can be placed side-by-side with the `side-by-side` shortcode:

{{< side-by-side >}}
{{< img src="typography-1.jpg" alt="Reproduction of a Gutenberg printing press" caption="A Gutenberg printing press" >}}
{{< img src="typography-3.jpg" alt="An old typewriter" caption="An old typewriter" >}}
{{< /side-by-side >}}

## Details

For long-form content that benefits from progressive disclosure, the `details` shortcode collapses content behind a clickable summary:

{{< details "Click to expand: typography history in brief" >}}
The history of Western typography begins with Gutenberg's movable type in the 15th century. The Special Elite typewriter face evokes early 20th-century typewriters; Garamond and similar serifs trace back to the French Renaissance; Iosevka and other monospaced faces are children of the digital age.

This collapsible block supports full Markdown — including **bold**, *italic*, [links](https://example.com), and even nested shortcodes.
{{< /details >}}

## Footnotes

Footnotes are useful for adding context without breaking the flow of the main text[^1]. Multiple footnotes are supported[^2], and they collect together at the bottom of the article.

[^1]: This is the first footnote — typically used for citations or asides.
[^2]: A second footnote can include **formatting** and [links](https://gohugo.io).
