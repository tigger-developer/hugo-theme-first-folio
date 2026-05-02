---
title: "Shortcode Showcase"
date: 2025-12-01
description: "A comprehensive demonstration of every shortcode available in the tadg_ie theme."
tags:
  - theme
  - shortcodes
  - reference
toc: "Shortcodes"
author: "Theme Demo"
layout: hero
image:
  src: hero.jpg
  alt: "Creative tools and typography arranged as a flat lay"
  dark: true
signpost:
  text: "THEME DOCUMENTATION"
  url: "https://github.com/tigger04/theme-tadg-ie"
signpost_footer:
  text: "VIEW SOURCE ON GITHUB"
  url: "https://github.com/tigger04/theme-tadg-ie"
resources:
  - src: "gallery-1.jpg"
    params:
      title: "Amber gradient"
      caption: "Warm tones"
      weight: 1
  - src: "gallery-2.jpg"
    params:
      title: "Emerald gradient"
      caption: "Cool tones"
      weight: 2
  - src: "gallery-3.jpg"
    params:
      title: "Violet gradient"
      caption: "Deep tones"
      weight: 3
---

This page demonstrates every shortcode available in the tadg_ie theme. Use it as a visual reference.

## Callout

Four built-in types plus custom styling:

{{< callout type="tip" text="This is a tip callout — use it for helpful suggestions." >}}

{{< callout type="info" text="This is an info callout — use it for informational notes." >}}

{{< callout type="alert" text="This is an alert callout — use it for critical information." >}}

{{< callout type="warning" text="This is a warning callout — use it for cautionary notes." >}}

{{< callout type="info" title="Buy Now" text="Available worldwide" link="https://example.com" align="center" width="60%" >}}

{{< callout type="custom" title="Custom Callout" text="This callout has a custom title and background colour." style="background: hsl(210, 30%, 30%); color: #eee;" >}}

With float positioning:

{{< callout type="tip" text="This callout floats to the right of the content." position="right" >}}

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris. The callout sits alongside this paragraph text, demonstrating the float position parameter.

## Centre

{{< center >}}
This text is centred using the centre shortcode.
{{< /center >}}

## Colorbold

Inline highlighted text in the theme's secondary accent colour:

This recipe calls for {{< colorbold "really good butter" >}} — the kind from a farmers' market.

Without the underline: {{< colorbold text="no underline here" underlined="false" >}}.

## Details

Collapsible content using the HTML `<details>` element:

{{< details "Click to expand this section" >}}
This content is hidden by default. It can contain **bold text**, *italic text*, `code`, and other Markdown formatting.

- List items work too
- As do other block elements
{{< /details >}}

## Dialogue

For plays and screenplays — character name in small caps with optional parenthetical:

{{< dialogue "ELENA" >}}Have you seen the forecast?{{< /dialogue >}}

{{< dialogue "MARCUS" "checking his phone" >}}Rain again. Third day running.{{< /dialogue >}}

{{< dialogue "ELENA" "sighing" >}}At least the garden is happy.{{< /dialogue >}}

## Direction

Stage directions for dramatic scripts:

{{< direction >}}The cafe. Morning light through rain-streaked windows. ELENA and MARCUS at a corner table.{{< /direction >}}

{{< direction >}}Pause. The sound of rain intensifies.{{< /direction >}}

## Ga (Irish language)

Inline Irish language text with the correct font and `lang="ga"` attribute:

He greeted her with {{< ga >}}Dia duit, a chara{{< /ga >}} as she entered.

## Gallery

Displays page image resources as a responsive grid with lightbox:

{{< gallery exclude="sample-a.jpg,sample-b.jpg" >}}

## Img

The `img` shortcode embeds a page resource image with positioning, caption, and optional blur:

{{< img src="sample-a.jpg" alt="Purple gradient demo image" caption="A demo image" position="right" width="40%" >}}

This paragraph demonstrates the `img` shortcode floated to the right. The image sits alongside the text, wrapping naturally. The shortcode generates responsive thumbnails with WebP support, matching the gallery behaviour.

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

With the `noborder` parameter to remove the accent border:

{{< img src="sample-b.jpg" alt="Blue gradient demo image" position="center" width="50%" noborder="true" >}}

## Poem

Preserves line breaks exactly as written — essential for verse:

{{< poem >}}
The rain falls soft on Connacht stone,
on field and wall and empty lane,
on everything I've ever known
and some things I won't know again.
{{< /poem >}}

## Popquote

Expandable quote with a summary line:

{{< popquote "The best time to plant a tree was twenty years ago..." >}}
The best time to plant a tree was twenty years ago. The second best time is now.

This shortcode is useful for long quotations that would interrupt the flow of an article. The reader can choose to expand it.
{{< /popquote >}}

## Quote

Pull-quote with decorative quotation marks and optional attribution:

{{< quote attribution="Oscar Wilde" >}}
Be yourself; everyone else is already taken.
{{< /quote >}}

{{< quote >}}
A quote without attribution still gets the decorative marks.
{{< /quote >}}

## Raw HTML

Passes HTML through without Markdown processing:

{{< rawhtml >}}
<div style="padding: 1rem; border: 2px dashed var(--border-color, #ddd); border-radius: 0.5rem; text-align: center;">
  <p style="margin: 0;">This is raw HTML passed through the <code>rawhtml</code> shortcode.</p>
</div>
{{< /rawhtml >}}

## Section List

Renders navigation links to site sections:

{{< section-list >}}

With a limit parameter to show recent items per section:

{{< section-list limit="2" >}}

## Side-by-Side

Places two items side by side on desktop, stacked on mobile:

{{< side-by-side >}}
{{< img src="sample-a.jpg" alt="Purple gradient" >}}
{{< img src="sample-b.jpg" alt="Blue gradient" >}}
{{< /side-by-side >}}

## Video

Embeds a local video file with HTML5 player controls:

```text
{{</* video "/videos/sample.mp4" */>}}
```

(Place a video file at `static/videos/sample.mp4` to see this in action.)

## Contact Form

Self-hosted contact form with Cloudflare Turnstile CAPTCHA:

```text
{{</* contactform newsletter="true" */>}}
```

(Requires Cloudflare Worker configuration. See [docs/contactform.md](https://github.com/tigger04/theme-tadg-ie/blob/main/docs/contactform.md) for setup.)

## Formspree

A simpler contact form using Formspree as the backend:

```text
{{</* formspree id="your-form-id" */>}}
```

(Replace with your actual Formspree form ID.)
