---
title: "Shortcode Showcase"
date: 2025-12-01
description: "A comprehensive demonstration of every shortcode available in the First Folio theme."
tags:
  - theme
  - shortcodes
  - reference
toc: "Shortcodes"
author: "Theme Demo"
layout: hero
carousel: true
image:
  src: hero.jpg
  alt: "Creative tools and typography arranged as a flat lay"
  card_src: sample-a.jpg    # used on masonry cards instead
  card_position: center center # crop position on cards
  carousel_src: gallery-2.jpg     # used on carousel cards instead
  carousel_position: center  # crop position on carousel  
signpost:
  text: "THEME DOCUMENTATION"
  url: "https://github.com/tadg-paul/hugo-theme-first-folio"
signpost_footer:
  text: "VIEW SOURCE ON GITHUB"
  url: "https://github.com/tadg-paul/hugo-theme-first-folio"
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

This page demonstrates every shortcode available in the First Folio theme. Use it as a visual reference.

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

## `center`

{{< center >}}
This text is centred using the `center` shortcode.
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

## Spoiler

Spoilers conceal plot details until the reader deliberately reveals them. Inline spoilers remain within the surrounding sentence: the apparently harmless village doctor is {{< spoiler "the saboteur" />}}, but the review can discuss motive without exposing that fact.

Named text and a custom label are also supported: {{< spoiler text="the missing diary was forged" label="Character reveal" />}}. Adjacent spoilers keep independent reveal state: {{< spoiler "the red key" />}} and {{< spoiler "the blue door" />}}.

Use the paired form for a larger spoiler block:

{{< spoiler label="Ending details" >}}
The final scene reveals **why the letters stopped** and resolves the [opening mystery](https://example.com/review-notes).

- The first clue is reinterpreted.
- The last conversation gains a different meaning.
{{< /spoiler >}}

## Dialogue

For plays and screenplays — character name in small caps with optional parenthetical:

{{< dialogue "ELENA" >}}Have you seen the forecast?{{< /dialogue >}}

{{< dialogue "MARCUS" "checking his phone" >}}Rain again. Third day running.{{< /dialogue >}}

{{< dialogue "ELENA" "sighing" >}}At least the garden is happy.{{< /dialogue >}}

## Direction

Stage directions for dramatic scripts:

{{< direction >}}The cafe. Morning light through rain-streaked windows. ELENA and MARCUS at a corner table.{{< /direction >}}

{{< direction >}}Pause. The sound of rain intensifies.{{< /direction >}}

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

Pull-quote with decorative quotation marks. Two paths: the back-compat `attribution=` for a single-line credit, and the structured-fields path for richer testimonial layouts (name, role, organisation, photo, featured modifier).

### Back-compat — single-line `attribution`

{{< quote attribution="Oscar Wilde" >}}
Be yourself; everyone else is already taken.
{{< /quote >}}

### Unattributed

{{< quote >}}
A quote without attribution still gets the decorative marks.
{{< /quote >}}

### Structured — name only

{{< quote name="Frodo Baggins" >}}
There and back again, and many adventures along the way.
{{< /quote >}}

### Structured — name and role

{{< quote name="Sherlock Holmes" role="Consulting Detective" >}}
When you have eliminated the impossible, whatever remains, however improbable, must be the truth.
{{< /quote >}}

### Structured — name and organisation

{{< quote name="Hermione Granger" organization="Ministry of Magic" >}}
Books! And cleverness! There are more important things — friendship and bravery.
{{< /quote >}}

### Structured — name, role, organisation, page-resource photo, featured

{{< quote name="Aragorn" role="Ranger of the North" organization="Heirs of Isildur" photo="sample-a.jpg" featured=true >}}
The road goes ever on and on, down from the door where it began.
{{< /quote >}}

### Structured — photo from site-root path

{{< quote name="Gandalf" role="Wizard" photo="/icons/chevron-right-thick.svg" >}}
All we have to decide is what to do with the time that is given us.
{{< /quote >}}

### Structured — photo from absolute URL

{{< quote name="Bilbo Baggins" role="Hobbit of the Shire" photo="https://example.com/portrait.jpg" >}}
It's a dangerous business, going out your door.
{{< /quote >}}

### Edge case — unresolvable photo emits a build warning and omits the `<img>`

The filename `intentionally-missing-file.jpg` below does not exist in the page bundle; it's the demo for the unresolvable-photo path. Running `hugo` or `hugo server` will print a WARN line on stderr referencing the filename. The `<img>` element is omitted from the rendered HTML — the attribution still renders, just without a photo. This warning is **intentional** and exercises `RT-54.11` in the theme's regression suite.

{{< quote name="Tom Bombadil" role="Master of Wood, Water and Hill" photo="intentionally-missing-file.jpg" >}}
Hey dol! Merry dol! Ring a dong dillo!
{{< /quote >}}

### Back-compat precedence — `attribution=` set alongside structured fields uses `attribution=`

When both are set on the same shortcode, `attribution=` wins and the structured fields (including any photo) are ignored. Sites migrating from the legacy form can leave both during the transition.

{{< quote attribution="Oscar Wilde" name="Should Be Ignored" photo="sample-a.jpg" >}}
The truth is rarely pure and never simple.
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

## Stats

A pair of shortcodes for portfolio / consultancy "stats rows" — a number paired with a short label. Use `stat` standalone, or wrap several in `stats` for a responsive grid.

### Standalone

A single stat block, used inline:

{{< stat number="80" label="Countries" >}}

### Prefix and suffix

Optional `prefix` and `suffix` add small adornments around the number:

{{< stat number="20" label="Years" prefix="~" suffix="+" >}}

### Wrapped — auto-fit responsive grid

The default `{{</* stats */>}}` wrapper lays children out with `auto-fit` columns. The layout reflows to fewer columns as the viewport narrows:

{{< stats >}}
{{< stat number="40" label="Years experience" >}}
{{< stat number="80" label="Countries advised" >}}
{{< stat number="200" suffix="+" label="Parties advised" >}}
{{< /stats >}}

### Wrapped — fixed columns

Pass `columns=N` to fix the column count regardless of viewport. Useful when the row would otherwise reflow to a layout that looks unbalanced:

{{< stats columns=4 >}}
{{< stat prefix="£" number="500" suffix="k" label="Saved" >}}
{{< stat number="12" label="Awards" >}}
{{< stat number="4.7" suffix="/5" label="Score" >}}
{{< stat number="99.9" suffix="%" label="Uptime" >}}
{{< /stats >}}

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

(Requires Cloudflare Worker configuration. See [docs/contactform.md](https://github.com/tadg-paul/hugo-theme-first-folio/blob/main/docs/contactform.md) for setup.)

## Formspree

A simpler contact form using Formspree as the backend:

```text
{{</* formspree id="your-form-id" */>}}
```

(Replace with your actual Formspree form ID.)
