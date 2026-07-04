# First Folio Example Site

A demonstration site for the [First Folio Hugo theme](https://github.com/tadg-paul/hugo-theme-first-folio).

## Quick Start

```bash
make serve
```

Run this from the theme repository root, then open <http://127.0.0.1:1313>. Override `HUGO_BIND` or `HUGO_PORT` if needed.

## Content Sections

| Section | Features Demonstrated |
|---------|----------------------|
| **Recipes** | Masonry card grid, sidebar mode 2 (content markdown with section-list), tags, callout/details/colorbold shortcodes, `pin`, `hideDate` |
| **Journal** | All 7 single-page layouts (banner, hero, columns, featured-columns-right, featured, background, default), TOC, TL;DR, popquote shortcode, dark mode reference, navigation features |
| **Photography** | Gallery subsections, `gallery: true`, lightbox, EXIF metadata, sidebar mode 4 (root-based) |
| **Stories** | List view, dialogue/direction/poem shortcodes, sidebar mode 3 (explicit sections) |
| **Poetry** | Masonry cards, recursive listing, nested collections (half-remembered/), sidebar mode 4 (root-based), `hideDate` cascade, `pin`, poem shortcode |
| **Podcast** | Theme-owned audio page layout, episode audio controls, episodic feed metadata, generated media facts, podcast feed at `/podcast-demo/feed.xml` |
| **Audiobook** | Theme-owned audio page layout, chapter audio controls, serial feed metadata, local listening-position storage, audiobook feed at `/audiobook-demo/feed.xml` |

## Feature Coverage

### Display Styles
- **Masonry grid (cards):** Homepage, journal/, recipes/, poetry/
- **List view:** stories/
- **Gallery view:** photography/

### Sidebar Modes
- **Mode 1 - simple (`true`):** journal/
- **Mode 2 - content (markdown):** Homepage, recipes/
- **Mode 3 - explicit sections:** stories/
- **Mode 4 - root-based:** photography/, poetry/

### Single-Page Layouts
- **banner:** journal/typography-guide/
- **hero:** journal/masonry-explained/, journal/navigation-features/
- **columns:** journal/on-walking/
- **featured-columns-right:** journal/dark-mode-setup/
- **featured:** journal/featured-image/
- **background:** journal/background-images/
- **default (text-only):** journal/shortcode-showcase/

### Shortcodes (all 18)
All shortcodes are demonstrated in the [Shortcode Showcase](/journal/shortcode-showcase/) page and/or throughout the site content:

| Shortcode | Showcase | Also Used In |
|-----------|----------|-------------|
| callout (4 types + float) | Yes | recipes, journal articles |
| centre | Yes | - |
| colorbold | Yes | recipes/colcannon |
| contactform | Documented | - |
| details | Yes | recipes, stories |
| dialogue | Yes | stories/the-waiting-room |
| direction | Yes | stories/the-waiting-room |
| formspree | Documented | - |
| ga | Yes | - |
| gallery | Yes | photography/ galleries |
| img (incl. noborder) | Yes | - |
| poem | Yes | stories/morning-song, all poetry/ |
| popquote | Yes | journal/on-walking |
| quote | Yes | - |
| rawhtml | Yes | - |
| section-list | Yes | homepage sidebar, recipes sidebar |
| side-by-side | Yes | - |
| video | Documented | - |

### Navigation and CTA Features
- **Breadcrumb trail:** journal/shortcode-showcase/, journal/navigation-features/
- **Signpost CTA (header):** journal/shortcode-showcase/, journal/navigation-features/
- **Signpost CTA (footer):** journal/shortcode-showcase/, journal/navigation-features/
- **TOC:** typography-guide, shortcode-showcase, dark-mode-setup, navigation-features

### Other Features
- **Dark mode design**
- **Responsive grid config:** Full breakpoint configuration in hugo.yaml
- **TL;DR summary:** typography-guide
- **Content pinning:** soda-bread, colcannon, typography-guide, the-cartographer
- **hideDate:** miso-aubergine, poetry/ (via cascade)
- **Tags & taxonomy pages:** All sections
- **Recursive listing:** poetry/ (includes nested collections)
- **Nested sections:** poetry/half-remembered/
- **Social icons:** Both Feather (github, rss) and Simple Icons (bluesky, mastodon)
- **Background images with blur:** Journal articles with image frontmatter
- **Pagination:** Per-section config
- **Podcast demo:** Audiobook content page and RSS feed backed by repository-local `.m4a` files

## Adding Images

The photography galleries are empty by default. To see the gallery and lightbox features in action, add `.jpg` or `.png` images to:

- `content/photography/coastal-walks/`
- `content/photography/market-mornings/`

Hugo will process them automatically with responsive sizing and WebP conversion.

## Configuration

See `hugo.yaml` for all theme parameters. Key settings demonstrated:

- `params.grid` - full responsive breakpoint configuration
- `params.mainSections` - controls homepage masonry grid content
- `menu.main` - navigation entries including Poetry, Podcast, and Tags
- `params.bgImage` - background image opacity and blur defaults
- `params.social` - both Feather and Simple Icons icon types

## License

MIT License. Content is fictional and for demonstration purposes only.
