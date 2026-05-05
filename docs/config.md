<!-- Version: 1.0 | Last updated: 2026-05-05 -->

# Configuration Reference

All configuration lives in `hugo.yaml` (or `hugo.toml` / `hugo.json`) under the `params` key. Every parameter has a sensible hardcoded default - a site works with no `params` block at all.

---

## Ambience (colour mode)

Controls the site's light/dark mode behaviour.

```yaml
params:
  ambience:
    default: auto       # auto | light | dark
    toggle: true        # show the user a light/dark toggle button
```

| Key | Default | Description |
|-----|---------|-------------|
| `default` | `auto` | Starting colour mode. `auto` follows the user's OS preference. `light` and `dark` force a fixed mode. |
| `toggle` | `true` | Whether to display a toggle button in the header. When `false`, the user cannot switch modes. |

**Note:** The previous `mode` parameter (`light`/`dark`/`auto`/`toggle`) is deprecated and ignored from v1.0.1. Use `ambience` instead.

---

## Background image defaults

Controls how images appear behind text - on background-layout articles, masonry cards, carousel cards, and list views. Images are always placed on a dark backing. Lowering opacity lets the dark backing show through, darkening the image for text readability.

```yaml
params:
  bgImage:
    opacity: 0.7        # image opacity (0.0–1.0). Lower = darker.
    blur: 2px            # blur applied to the image
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.7` | How transparent the image is. `1.0` = full image, `0.5` = half the dark backing shows through. |
| `blur` | `2px` | Gaussian blur on the image. Higher values soften the image for text readability. |

These are the base defaults. More specific contexts (cards, carousel, banner) fall back to these values when their own are not set.

---

## Card image settings

Controls images on masonry cards (the homepage grid).

```yaml
params:
  cardImage:
    opacity: 0.9         # card image opacity
    blur: 3px            # card image blur
    title:
      wash:
        opacity: 0.2     # title wash tint strength
        blur: 6px        # title wash backdrop blur
        gradientV: "20%" # vertical gradient fade at edges
        gradientH: "8%"  # horizontal gradient fade at edges
    description:
      wash:
        opacity: 0.5     # bottom scrim max opacity
        gradient: "75%"  # where scrim reaches full opacity (% from top of scrim)
```

### Title wash

A soft-edged tinted layer behind the card title text. Uses gradient masking so the edges dissolve into the image rather than showing a hard box.

| Key | Default | Description |
|-----|---------|-------------|
| `title.wash.opacity` | `0.2` | Tint strength behind the title. |
| `title.wash.blur` | `6px` | Backdrop blur behind the title. |
| `title.wash.gradientV` | `20%` | How far the vertical fade extends inward from each edge. Higher = more fade. |
| `title.wash.gradientH` | `8%` | How far the horizontal fade extends inward from each edge. |

### Description wash

A bottom-up gradient scrim behind the card excerpt/description area.

| Key | Default | Description |
|-----|---------|-------------|
| `description.wash.opacity` | `0.5` | Maximum opacity at the bottom of the scrim. |
| `description.wash.gradient` | `75%` | The point (from the top of the scrim area) where the gradient reaches full opacity. Lower = scrim starts being opaque earlier. |

---

## Gallery card image settings

Controls images on gallery/artwork masonry cards. These show the full image at 100% opacity with no blur (the image is the content), so the title and footer need stronger wash treatment.

```yaml
params:
  cardGalleryImage:
    title:
      wash:
        opacity: 0.35    # frosted pill opacity
        blur: 5px        # frosted pill blur
    description:
      wash:
        opacity: 0.5     # footer scrim max opacity
        gradient: "75%"  # where scrim reaches full opacity
```

Gallery card titles use a hard-edged frosted pill rather than the soft-edged gradient mask of regular cards, because the image is at full opacity and needs stronger contrast.

---

## Carousel settings

Controls the rotating hero card above the masonry grid on the homepage.

```yaml
params:
  carousel:
    interval: 6          # seconds between slides
    bgImage:
      opacity: 0.9       # carousel image opacity
      blur: 0px          # carousel image blur
```

| Key | Default | Description |
|-----|---------|-------------|
| `interval` | `6` | Seconds between automatic slide transitions. |
| `bgImage.opacity` | `0.9` | Image opacity on carousel cards. Falls back to `bgImage.opacity` if not set. |
| `bgImage.blur` | `0px` | Image blur on carousel cards. Falls back to `bgImage.blur` if not set. |

---

## Background-layout wash

Controls the tinted overlay behind text panels on background-layout article pages. This is the wash that makes body text readable over a full-page background image.

```yaml
params:
  wash:
    opacity: 0.25        # tint strength (0 = none, 1 = solid)
    blur: 0px            # backdrop blur behind text panels
    gradient: "0% 10% 0% 10%"  # edge fade: left top right bottom
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.25` | Dark tint strength behind text panels. |
| `blur` | `0px` | Backdrop blur applied to text panels. |
| `gradient` | `0% 10% 0% 10%` | How far the wash fades at each edge (left, top, right, bottom). Higher values = more fade. Accepts 1, 2, or 4 values. |

Per-page override: set `image.wash` in frontmatter (see [Frontmatter Reference](frontmatter.md)).

---

## Banner wash

Controls the tinted overlay behind the title on banner-layout pages.

```yaml
params:
  banner:
    wash:
      opacity: 0.3       # wash tint strength
      blur: 2px          # backdrop blur
      gradient: "20% 30% 20% 30%"  # edge fade: left top right bottom
```

| Key | Default | Description |
|-----|---------|-------------|
| `opacity` | `0.3` | Dark tint strength behind the banner title. |
| `blur` | `2px` | Backdrop blur behind the title area. |
| `gradient` | `20% 30% 20% 30%` | Edge fade distances. Banner uses heavier fade than background-layout to avoid a visible box over the image. |

Per-page override: set `image.banner_wash` in frontmatter (see [Frontmatter Reference](frontmatter.md)).

---

## Read more button

Controls the "read more" indicator on masonry cards.

```yaml
params:
  readMore:
    type: icon                              # "icon" or "text"
    value: icons/chevron-right-duo-thick.svg # icon path or text string
    valueDark: ""                            # optional dark-mode variant icon
```

---

## Grid configuration

Controls the responsive masonry grid layout.

```yaml
params:
  grid:
    contentMaxWidth: 100rem
    sidebarWidth: 15rem
    sidebarWidthNarrow: 12rem
    gap: 1.5rem
    breakpoints:
      sm: 30em
      md: 48em
      lg: 64em
      xl: 80em
    columns:
      sm: 2
      md: 3
      lg: 4
      xl: 5
```

All values above are the defaults. Per-section overrides are supported via `grid` in section `_index.md` frontmatter.

---

## Social links

Displayed as icons in the footer.

```yaml
params:
  social:
    - name: GitHub
      icon: github                    # Feather icon (default)
      url: https://github.com/username
    - name: BlueSky
      icon: "simple:bluesky"          # Simple Icons (simple: prefix)
      url: https://bsky.app/profile/username
    - name: RSS
      icon: rss
      url: /index.xml
```

Icons can be Feather icons (bare name) or Simple Icons (prefixed with `simple:`).

---

## Other settings

```yaml
params:
  browserTitle: "Custom Browser Tab Title"  # overrides site title in <title> only
  dateFormat: "2 January 2006"              # Go date format for article pages
  dateFormatShort: "02/01/06"               # short format for cards
  subtitle: "A tagline for the site"
  useCDN: false                             # true to load icons from CDN
  mathjax: false                            # enable MathJax maths rendering
  katex: false                              # enable KaTeX maths rendering
  favicon: /favicon.ico                     # path to favicon

  mainSections:                             # sections shown on homepage
    - blog
    - gallery
    - poetry

  customCSS:                                # additional CSS files
    - css/custom.css
    - css/fonts.css

  customJS:                                 # additional JavaScript files
    - js/lightbox.js
```

---

## Menu

```yaml
menu:
  main:
    - name: Blog
      url: /blog/
      weight: 10
    - name: Gallery
      url: /gallery/
      weight: 20
```

Lower weight = appears first in navigation.

---

## Full example

See `exampleSite/config/_default/hugo.yaml` for a complete working configuration.
