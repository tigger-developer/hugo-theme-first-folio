# Shortcodes Reference

The tadg_ie theme provides 18 custom shortcodes for varied content types.

## Table of Contents

1. [callout](#callout) - Styled alert/notice boxes
2. [centre](#centre) - Centre-aligned content block
3. [colorbold](#colorbold) - Inline accent-coloured bold text
4. [details](#details) - Collapsible content
5. [dialogue](#dialogue) - Character speech for plays
6. [direction](#direction) - Stage directions
7. [ga](#ga) - Inline Irish language text
8. [popquote](#popquote) - Expandable quotes
9. [quote](#quote) - Pull-quote with decorative quotation marks and attribution
10. [poem](#poem) - Poetry with preserved line breaks
11. [video](#video) - HTML5 video player
12. [contactform](#contactform) - Self-hosted contact form with CAPTCHA
13. [formspree](#formspree) - Formspree-backed contact form
14. [rawhtml](#rawhtml) - Raw HTML pass-through
15. [section-list](#section-list) - Section navigation list
16. [img](#img) - Inline image with responsive thumbnails
17. [gallery](#gallery) - Image gallery with lightbox
18. [side-by-side](#side-by-side) - Side-by-side content wrapper

---

## callout

Styled alert/callout boxes with colour-coded types.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `type` | Yes | One of: `info`, `tip`, `alert`, `warning`, `custom` |
| `text` | Yes | Message content |
| `title` | No | Custom title (for `info`, `tip`, `warning`, `custom` - overrides the default) |
| `link` | No | URL - makes the title a clickable link |
| `linktext` | No | Link text when `link` is used without a title (default: "More info") |
| `align` | No | Text alignment: `left`, `center`, `right` |
| `width` | No | Max width of the callout box, any CSS unit (`30rem`, `60%`, etc.). Box is auto-centred on the page |
| `position` | No | Float direction: `left` or `right`. Omit for default block layout |
| `style` | No | Inline CSS (only for `type="custom"`) |

### Usage

```markdown
{{< callout type="tip" text="This is a helpful tip!" >}}
{{< callout type="info" text="Informational note" >}}
{{< callout type="info" title="Buy Now" text="Available worldwide" link="https://example.com" align="center" width="60%" >}}
{{< callout type="alert" text="Important alert message" >}}
{{< callout type="warning" text="Warning message" >}}
{{< callout type="custom" title="Custom Title" text="Custom message" style="background: #fee;" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#callout).

---

## centre

Centre-aligned content block. Wraps inner content in a `<div class="text-center">`.

**Note:** In Org-mode files, shortcodes with inner Org markup (links, lists) may not render correctly. For Org content, prefer using `#+BEGIN_EXPORT html` with `<div class="text-center">` directly.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Content to centre |

### Usage

```markdown
{{< center >}}
This text is centred.
{{< /center >}}
```

**Org-mode alternative:**

```org
#+BEGIN_EXPORT html
<div class="text-center">
<p>Centred text with <a href="https://example.com">a link</a></p>
</div>
#+END_EXPORT
```

---

## colorbold

Inline text rendered in the secondary accent colour (`--color-secondary`) and bold. Underlined by default. Designed for emphasis within a sentence.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional or `text` | Yes | Text to display |
| `underlined` | No | Set to `"false"` to remove underline (default: `true`) |

### Usage

```markdown
Are these only {{< colorbold "words" >}} I'm meant to frame?
This has {{< colorbold text="no underline" underlined=false >}} here.
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#colorbold).

---

## details

Collapsible content block. Closed state shows an ellipsis hint; open state reveals full content.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Summary/title text (supports markdown) |
| Inner content | Yes | Body content (supports markdown) |

### Usage

```markdown
{{< details "Click to expand" >}}
Hidden content goes here.
Can include **markdown**.
{{< /details >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#details).

---

## dialogue

Character speech for plays and screenplays. Character name renders in small caps with optional parenthetical (delivery direction) in italics.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional or `name` | Yes | Character name |
| Second positional or `parenthetical` | No | Delivery direction |
| Inner content | Yes | Dialogue text |

Supports both positional and named parameters.

### Usage

```markdown
{{< dialogue "TOM" "pleading" >}}Please don't shake off the water!{{< /dialogue >}}
{{< dialogue "ALISON" >}}You've waited since yesterday, Tom.{{< /dialogue >}}
{{< dialogue name="BAYANI" parenthetical="chuckling" >}}Oh is that all?{{< /dialogue >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#dialogue).

---

## direction

Stage directions for plays. Renders in italics with secondary accent colour.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Stage direction text (supports markdown) |

### Usage

```markdown
{{< direction >}}A bare stage. Single chair centre. TOM enters.{{< /direction >}}
{{< direction >}}Pause.{{< /direction >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#direction).

---

## ga

Inline Irish language text. Wraps content in `<span lang="ga">`, triggering the `:lang(ga)` CSS rule which applies Iosevka Gaeilge (wedge serif variant). Use this for Irish words or phrases within English text. For whole articles in Irish, use `contentLang: ga` in front matter instead.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Irish language text |

### Usage

```markdown
He greeted her with {{</* ga */>}}Dia duit, a chara{{</* /ga */>}} as she entered.
The word {{</* ga */>}}craic{{</* /ga */>}} has no direct English equivalent.
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#ga-irish-language).

---

## popquote

Expandable quote using the same collapsible styling as `details`.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Opening/summary text |
| Inner content | Yes | Full quote content (supports markdown) |

### Usage

```markdown
{{< popquote "Opening line..." >}}
Full quote content here.
Multiple paragraphs supported.
{{< /popquote >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#popquote).

---

## quote

Pull-quote with a decorative opening quotation mark and an optional attribution line. Block-form shortcode - the body is markdown and can span multiple lines, contain inline formatting, links, and other shortcodes.

Distinct from [`popquote`](#popquote) which is a collapsible expandable quote; `quote` is an always-visible featured pull-quote intended to draw the eye within the flow of an article.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `attribution` | No | Source of the quote - rendered as a right-aligned caption, automatically prefixed with an em-dash |
| Inner content | Yes | The quote text itself; supports full markdown |

### Usage

With attribution:

```markdown
{{< quote attribution="A. Person" >}}
The actual quote text - can include **bold**, *italic*, [links](https://example.com),
and span multiple lines.
{{< /quote >}}
```

Without attribution:

```markdown
{{< quote >}}
An unattributed pull-quote.
{{< /quote >}}
```

### Styling

- Large decorative opening quotation mark (`"`) in the theme's primary accent colour (`--color-primary`), positioned top-left at ~7rem tall
- Quote body in italic, slightly larger than body text, full body colour in both light and dark mode
- Attribution caption right-aligned in a muted shade (faded to ~65% of the body colour), prefixed with an em-dash via CSS
- Responsive: on screens narrower than ~32rem the decorative quote mark shrinks and the indent tightens

---

## poem

Poetry formatting with preserved line breaks. Newlines in source convert to `<br />` tags so verse structure is maintained.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Poem text with line breaks |

### Usage

```markdown
{{< poem >}}
Roses are red,
Violets are blue,
This preserves
Line breaks for you.
{{< /poem >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#poem).

---

## video

Embed video - either local files via HTML5 `<video>` or Cloudflare Stream videos via iframe. The shortcode auto-detects the source type from the argument.

### Detection Logic

- **32-character hex string** (positional or `id` named param) -> Cloudflare Stream iframe embed
- **Anything else** (file path or URL) -> local HTML5 `<video>` player

### Parameters

**Local video (positional):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | Video file path or URL |

**Cloudflare Stream (positional - no player options):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| First positional | Yes | 32-character Cloudflare Stream video UID |

**Cloudflare Stream (named - with player options):**

| Parameter | Required | Description |
|-----------|----------|-------------|
| `id` | Yes | 32-character Cloudflare Stream video UID |
| `autoplay` | No | Auto-start playback (`true`/`false`) |
| `muted` | No | Start muted (`true`/`false`) |
| `loop` | No | Repeat on end (`true`/`false`) |
| `controls` | No | Show player controls (default: `true`) |
| `preload` | No | Browser preload hint (`none`, `metadata`, `auto`) |
| `poster_image` | No | Thumbnail shown before playback - see [Poster Image Resolution](#poster-image-resolution) |
| `startTime` | No | Start at specific time (e.g. `1m30s`) |
| `primaryColor` | No | Player UI accent colour (URI-encoded CSS) |
| `letterboxColor` | No | Player background colour (URI-encoded CSS) |

**Note:** Hugo shortcodes do not allow mixing positional and named parameters. Use all-named syntax (`id="..."`) when you need player options.

### Site Configuration (Cloudflare Stream)

Cloudflare Stream requires a customer code in `hugo.yaml`:

```yaml
params:
  cloudflareStream:
    customerCode: "YOUR_CUSTOMER_CODE"
```

The customer code is the public subdomain identifier visible in all embed URLs - it is not a secret.

#### Site-wide Video Defaults

You can set site-wide defaults for video player params. These apply to every video embed that does not explicitly set that param in page frontmatter or shortcode attributes:

```yaml
params:
  cloudflareStream:
    customerCode: "YOUR_CUSTOMER_CODE"
    videoDefaults:
      autoplay: true    # autoplay all videos by default
      muted: false      # do not mute by default
      loop: false       # do not loop by default
```

**Precedence (highest to lowest):**
1. Page frontmatter / shortcode attribute
2. Site-wide `videoDefaults`
3. Absent - Cloudflare applies its own default

Page frontmatter takes precedence in all cases, including an explicit `false` which suppresses a site-wide `true`. Setting `autoplay: false` in frontmatter will prevent autoplay even when the site default is `autoplay: true`.

**Autoplay and iframe loading:** When autoplay is effectively true (via frontmatter or site default), the embed iframe uses `loading="eager"` so the player initializes immediately on page load. When autoplay is not enabled, `loading="lazy"` is used and the player defers until scrolled into view.

### Usage

**Local video:**

```markdown
{{< video "/videos/my-video.mp4" >}}
```

**Cloudflare Stream (simple):**

```markdown
{{< video "ea95132c15732412d22c1476fa83f27a" >}}
```

**Cloudflare Stream (with options):**

```markdown
{{< video id="ea95132c15732412d22c1476fa83f27a" autoplay="true" muted="true" loop="true" >}}
{{< video id="ea95132c15732412d22c1476fa83f27a" poster_image="toast.jpg" >}}
{{< video id="ea95132c15732412d22c1476fa83f27a" poster_image="https://example.com/thumb.jpg" >}}
```

### Video in Page Layouts

In addition to the shortcode, Cloudflare Stream videos can be used as the primary visual in page layouts via the `video` frontmatter field. This places the video in the layout's media slot (where `image` would normally go).

#### Frontmatter Schema

```yaml
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"   # CF Stream UID (required)
  caption: "Open Your Heart"                # optional
  width: 1080                               # optional - see Dimension Resolution below
  height: 1920                              # optional - see Dimension Resolution below
  poster_image: toast.jpg                   # optional - see Poster Image Resolution below
  autoplay: true                            # optional
  muted: true                               # optional
  loop: true                                # optional
  controls: true                            # optional (default: true)
  preload: "auto"                           # optional
  startTime: "5"                            # optional, seconds
  primaryColor: "#ff6600"                   # optional
  letterboxColor: "#000000"                 # optional
```

> **Boolean params and CF defaults:** Pass `true` to enable a feature. Omit the field (or set `false`) to use Cloudflare's default. Setting a boolean param to `false` is equivalent to not setting it - the param is not forwarded to the player URL. If site-wide `videoDefaults` are configured, a `false` value in page frontmatter overrides a `true` site default.

#### Compatible Layouts

| Layout | Behaviour |
|--------|-----------|
| `hero` | Video floats right, text wraps around it |
| `featured` | Video centred above content |
| `featured-columns-left` / `columns` | Video in left column, text in right |
| `featured-columns-right` | Text in left column, video in right |

**Incompatible layouts:** `banner` and `background` (default when `image` is set without a layout). These produce a Hugo build warning if `video` is present.

#### Dimension Resolution

The video container's `aspect-ratio` is resolved in this order:

1. **Frontmatter** - `video.width` and `video.height` if both are present
2. **Video inventory** - `data/video-inventory.yaml` in the site root, keyed by UID (`where .videos "uid" $id`)
3. **Cloudflare Stream API** - fetched at build time when `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` are set. Both vars must be listed under `security.funcs.getenv` in `hugo.yaml`. When the vars are absent, this step is silently skipped
4. **CSS default** - 16:9 (`aspect-ratio: 16 / 9` in the stylesheet); no inline style is added

For the inventory lookup to work, add a `data/video-inventory.yaml` to the site root with this format:

```yaml
videos:
  - uid: "fd20681eb60dc4cc9c2058f30b977a7a"
    width: 1080
    height: 1920
```

The upload script in the content repo (`scripts/upload-video.sh`) writes this format automatically.

#### Poster Image Resolution

The `poster_image` field sets a thumbnail shown in the CF player before the video plays. It is appended to the embed URL as `?poster=[url]`.

The value is resolved to an absolute URL based on its format:

| Format | Example | Resolved as |
|--------|---------|-------------|
| Relative filename (no leading `/`) | `toast.jpg` | `[page.Permalink]toast.jpg` |
| Site-root-relative (leading `/`) | `/images/thumb.jpg` | `[site.BaseURL]images/thumb.jpg` |
| Absolute URL | `https://cdn.example.com/thumb.jpg` | Used verbatim |

**Priority chain:**

1. Frontmatter `poster_image` (or shortcode `poster_image` param)
2. `poster_image` in `data/video-inventory.yaml` for the matching UID - must be an absolute URL
3. No poster - CF Stream default (first frame of video)

**Inventory format:**

```yaml
videos:
  - uid: "fd20681eb60dc4cc9c2058f30b977a7a"
    width: 1080
    height: 1920
    poster_image: "https://tadg.ie/poetry/secrets/open-your-heart/toast.jpg"
```

The inventory `poster_image` must be an absolute URL - the upload script cannot populate it automatically since it is site- and page-specific.

#### Precedence

If both `video` and `image` are set, `video` takes precedence in compatible layouts. A build warning is emitted noting the conflict.

#### Examples

**Hero with video:**

```yaml
---
title: "My Post"
layout: hero
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
  autoplay: true
  muted: true
  loop: true
---
```

**Columns with video:**

```yaml
---
title: "My Post"
layout: featured-columns-left
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
  caption: "Open Your Heart"
---
```

**Featured with video:**

```yaml
---
title: "My Post"
layout: featured
video:
  id: "fd20681eb60dc4cc9c2058f30b977a7a"
---
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#video).

---

## contactform

Self-hosted contact form with Cloudflare Turnstile CAPTCHA, Worker backend, and optional newsletter signup.

Requires Cloudflare Worker deployment and Hugo configuration. See [contactform.md](contactform.md) for the full setup guide.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `newsletter` | No | Set to `"true"` to show newsletter checkbox |

### Site Configuration Required

```yaml
params:
  contactform:
    worker_url: "https://your-worker.example.workers.dev"
    turnstile_sitekey: "0x..."
```

### Usage

```markdown
{{< contactform >}}
{{< contactform newsletter="true" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#contact-form).

---

## formspree

Contact form using Formspree as the backend. Simpler alternative to `contactform` - no CAPTCHA, no self-hosting required.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `id` | Yes | Formspree form ID |

### Usage

```markdown
{{< formspree id="your-formspree-id" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#formspree).

---

## rawhtml

Pass through raw HTML without markdown processing. Use for embedding widgets, iframes, or any HTML that Hugo's markdown renderer would alter.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Raw HTML content |

### Usage

```markdown
{{< rawhtml >}}
<div class="custom-widget">
  <iframe src="https://example.com/embed"></iframe>
</div>
{{< /rawhtml >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#raw-html).

---

## section-list

Renders a navigation list of site sections with chevron icons. Behaviour is consistent on any page (homepage, section pages, single pages).

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `sections` | No | Comma-separated section names (defaults to `site.Params.mainSections`) |
| `limit` | No | Number of recent items to show per section |

### Usage

```markdown
{{< section-list >}}
{{< section-list sections="blog,gallery" >}}
{{< section-list limit="3" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#section-list).

---

## img

Inline image for embedding within article text. Generates responsive thumbnails with WebP support, matching gallery behaviour.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `src` | Yes | Image filename (from page resources) |
| `alt` | Yes | Alt text for accessibility |
| `caption` | No | Caption text below image |
| `position` | No | Placement: `left`, `right` (default), or `center` |
| `width` | No | Width when floated - any CSS unit: `40%`, `15rem`, `30vw` (default: `40%`) |
| `link` | No | URL to wrap the image in a link |
| `noborder` | No | Set to `"true"` to remove the orange accent border |
| `blur` | No | Set to `"true"` for blurred caption background |
| `opacity` | No | Caption background opacity override |

### Usage

```markdown
{{< img src="photo.jpg" alt="A scenic view" >}}
{{< img src="portrait.jpg" alt="Author" caption="Photo by Jane" position="left" >}}
{{< img src="hero.jpg" alt="Banner" position="center" width="80%" >}}
{{< img src="cover.jpg" alt="Book cover" width="15rem" position="left" link="https://example.com/buy" >}}
{{< img src="mood.jpg" alt="Atmosphere" caption="Dreamy" blur="true" opacity="0.7" >}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#img).

---

## gallery

Displays page image resources as a responsive gallery with lightbox support.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `exclude` | No | Comma-separated filenames to exclude from gallery |

### Metadata Priority

1. Frontmatter resource params (`title`, `caption`, `alt`, `weight`)
2. EXIF data (`DocumentName` -> title, `ImageDescription` -> caption)
3. Filename (fallback)

### Frontmatter Configuration

```yaml
resources:
  - src: "*.jpg"
    params:
      weight: 10
  - src: "special.jpg"
    params:
      title: "Custom Title"
      caption: "Custom caption"
```

### Usage

```markdown
{{< gallery >}}
{{< gallery exclude="hero.jpg" >}}
{{< gallery exclude="inline1.jpg,inline2.jpg" >}}
```

Use `exclude` when you have images displayed inline (via `img` shortcode) that you don't want duplicated in the gallery grid.

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#gallery).

---

## side-by-side

Wrapper shortcode that places inner content side by side on desktop. Collapses to stacked layout on mobile (below 48em). Commonly used to wrap two `img` shortcodes.

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| Inner content | Yes | Content to arrange side by side (typically two shortcodes) |

### Usage

```markdown
{{</* side-by-side */>}}
{{</* img src="cover-front.jpg" alt="Front cover" link="https://example.com" */>}}
{{</* img src="cover-back.jpg" alt="Back cover" link="https://example.com" */>}}
{{</* /side-by-side */>}}
```

### Live Demo

See [live example on the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/#side-by-side).
