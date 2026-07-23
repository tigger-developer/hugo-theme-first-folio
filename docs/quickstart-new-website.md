# Quickstart: New Website with First Folio

A step-by-step guide for setting up a new Hugo site using the First Folio theme. No prior Hugo experience required.

## Prerequisites

- **Hugo Extended** (v0.128.0 or later): [Installation guide](https://gohugo.io/installation/)
- **Git**: [Download](https://git-scm.com/downloads)
- A terminal (Terminal on macOS, any shell on Linux, PowerShell or Git Bash on Windows)

Verify Hugo is installed:

```bash
hugo version
```

The output should include `extended` - First Folio requires the extended edition for image processing.

## Create the site

```bash
hugo new site my-site
cd my-site
```

This creates a new Hugo project with the standard directory structure.

## Add the theme

```bash
git init
git submodule add https://github.com/tigger-developer/hugo-theme-first-folio.git themes/first-folio
```

Then tell Hugo to use it. Open `hugo.yaml` and set:

```yaml
theme: first-folio
```

## Minimal configuration

Replace the contents of `hugo.yaml` with a sensible starting point:

```yaml
baseURL: https://example.com/
title: My Site
theme: first-folio

pagination:
  pagerSize: 12

params:
  mode: dark          # light, dark, auto, or toggle

  mainSections:
    - blog
    - gallery

  bgImage:
    opacity: 0.2
    blur: 5px

menu:
  main:
    - name: Blog
      url: /blog/
      weight: 10
    - name: Gallery
      url: /gallery/
      weight: 20
    - name: Tags
      url: /tags/
      weight: 30

taxonomies:
  tag: tags

imaging:
  quality: 90
  exif:
    disableLatLong: true
```

Adjust `baseURL`, `title`, section names, and menu entries to suit your site. For the full configuration reference, see the [theme README](../README.md#configuration-options).

## Create your first content

### A blog post

```bash
mkdir -p content/blog/my-first-post
```

Create `content/blog/my-first-post/index.md`:

```markdown
---
title: "My First Post"
date: 2025-01-15
description: "Getting started with Hugo and First Folio."
tags:
  - hello
layout: hero
image:
  src: hero.jpg
  alt: "A description of the image"
  dark: true
---

Write your content here. Standard Markdown is supported.

## Subheading

More content. Add images, links, lists — whatever you like.
```

Drop an image called `hero.jpg` into the same directory (`content/blog/my-first-post/`) and it will appear as the hero image.

### A section index

Create `content/blog/_index.md`:

```markdown
---
title: "Blog"
description: "Thoughts, notes, and observations."
list_style: cards
---
```

This tells First Folio to display the blog section as a masonry card grid. Other options are `list` and `gallery`.

### A gallery

```bash
mkdir -p content/gallery/my-photos
```

Create `content/gallery/_index.md`:

```markdown
---
title: "Gallery"
list_style: gallery
---
```

Create `content/gallery/my-photos/_index.md`:

```markdown
---
title: "My Photos"
gallery: true
---

{{</* gallery */>}}
```

Drop `.jpg` or `.png` images into `content/gallery/my-photos/` and they appear automatically. Hugo generates responsive thumbnails and WebP variants.

## Preview locally

```bash
hugo server
```

Open [http://localhost:1313](http://localhost:1313). The site rebuilds automatically as you edit.

To include draft posts:

```bash
hugo server -D
```

## Page bundles

First Folio works best with [page bundles](https://gohugo.io/content-management/page-bundles/) - each page is a directory containing an `index.md` and its associated resources (images, files). This keeps content self-contained and enables features like the `img` and `gallery` shortcodes.

```
content/
  blog/
    _index.md              # section index
    my-first-post/
      index.md             # the post
      hero.jpg             # hero image
      diagram.png          # inline image (use {{</* img */>}} shortcode)
    another-post/
      index.md
      banner.jpg
  gallery/
    _index.md
    landscapes/
      _index.md            # gallery index with {{</* gallery */>}}
      sunset.jpg
      mountains.jpg
```

## Using shortcodes

First Folio includes 18 shortcodes. A few to get started:

**Callout box:**
```markdown
{{</* callout type="tip" text="This is a helpful tip." */>}}
```

**Inline image** (from the page bundle):
```markdown
{{</* img src="diagram.png" alt="Architecture diagram" position="right" width="40%" */>}}
```

**Quote with attribution:**
```markdown
{{</* quote attribution="Someone Wise" */>}}
The important thing is not to stop questioning.
{{</* /quote */>}}
```

For the full shortcode reference with live examples, see [the demo site](https://demo.theme.tadg.ie/journal/shortcode-showcase/).

## Deploy

For GitHub Pages deployment, see [GitHub Pages Workflow](github-pages-workflow.md).

For other hosting options (Netlify, Cloudflare Pages, Vercel, self-hosted), see Hugo's [hosting and deployment guide](https://gohugo.io/hosting-and-deployment/).

## Next steps

- [Theme README](../README.md) - full feature reference, frontmatter fields, layout options
- [Shortcode reference](shortcodes.md) - all 18 shortcodes with parameters and examples
- [Hugo documentation](https://gohugo.io/documentation/) - the official Hugo docs
- [Hugo Discourse](https://discourse.gohugo.io/) - community support forum
