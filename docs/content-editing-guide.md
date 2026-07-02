# Content Editing Guide

A guide for non-developers who need to add or edit content on a Hugo site using the First Folio theme. No programming experience required.

## How it works

The website is built from plain text files. Each page on the site corresponds to a file in the `content/` folder. Edit the file, and the website updates.

If the site is hosted on GitHub Pages, changes are deployed automatically within a few minutes of saving. If someone runs it locally, changes appear instantly in the browser.

## Editing through GitHub

The simplest way to edit content is directly on GitHub - no software to install.

1. **Navigate to the file**: go to the `content/` folder in the repository and find the page
2. **Click the pencil icon** to edit
3. **Make changes** using Markdown (see below)
4. **Commit changes** using the button at the bottom - add a short note describing what changed
5. **Wait a few minutes** for the site to rebuild and deploy

## Markdown basics

Content is written in Markdown - a simple way to format text using punctuation characters. Here are the essentials:

### Text formatting

```markdown
**Bold text**
*Italic text*
***Bold and italic***
~~Strikethrough~~
```

### Headings

```markdown
# Page Title (largest)
## Section Heading
### Subsection
#### Smaller heading
```

Use headings to structure the page. The page title is set in the front matter (see below), so content usually starts with `##`.

### Links and images

```markdown
[Link text](https://example.com)

![Image description](photo.jpg)
```

For images, the file must be in the same folder as the page (see Page Bundles below).

### Lists

```markdown
- First item
- Second item
- Third item

1. Numbered item
2. Another item
3. And another
```

### Block quotes

```markdown
> This is a quote.
> It can span multiple lines.
```

### Code

Inline code uses backticks: `` `like this` ``

Code blocks use triple backticks:

````markdown
```
This is a code block.
Multiple lines are fine.
```
````

## Front matter

Every page starts with a block of settings between `---` lines. This is called front matter.

```markdown
---
title: "My Page Title"
date: 2025-06-15
description: "A short summary for search engines and previews."
author: "Your Name"
tags:
  - topic-one
  - topic-two
draft: false
---

Your content starts here.
```

### Common fields

| Field | What it does |
|-------|-------------|
| `title` | The page title displayed on the site |
| `date` | Publication date (YYYY-MM-DD format) |
| `description` | Short summary - appears in search results and card previews |
| `author` | Author name - appears in the breadcrumb |
| `tags` | Categories for the page - each on its own line with a `-` prefix |
| `draft: true` | Hides the page from the live site (set to `false` to publish) |

### Adding an image to a page

To use a hero or banner image, add an `image` block to the front matter:

```markdown
---
title: "My Page"
layout: hero
image:
  src: my-photo.jpg
  alt: "A description of the image for accessibility"
  dark: true
---
```

The image file (`my-photo.jpg`) must be in the same folder as `index.md`.

## Page bundles

Each page is a folder containing an `index.md` file and any associated images or files:

```
content/
  blog/
    my-post/
      index.md        <- the page content
      hero.jpg         <- hero image
      diagram.png      <- image used in the text
```

This keeps everything for one page together. To add an image to a post, drop the file into the page's folder and reference it by filename.

## Common tasks

**Create a new blog post:**
1. Create a new folder under the appropriate section (e.g. `content/blog/my-new-post/`)
2. Create `index.md` inside it with front matter and content
3. Add any images to the same folder

**Hide a page temporarily:**
Change `draft: false` to `draft: true` in the front matter.

**Change the order of pinned content on the homepage:**
Add `pin: 10` to the front matter. Lower numbers appear first.

**Add a page to the carousel:**
Add `carousel: 10` to the front matter. The page needs an image.

## Using shortcodes

Shortcodes add special formatting beyond what Markdown offers. They look like this:

```
{{</* callout type="tip" text="A helpful tip for the reader." */>}}
```

Some commonly used ones:

| Shortcode | What it does |
|-----------|-------------|
| `callout` | Coloured alert or tip box |
| `quote` | Styled pull-quote with attribution |
| `img` | Image with positioning and captions |
| `gallery` | Display all images in the page folder as a grid |
| `details` | Collapsible section (click to expand) |

For the full list with examples, see the [shortcode showcase](https://first-folio.demo.lobb.ie/journal/shortcode-showcase/).

## Getting help

1. Check this guide and the examples on the [demo site](https://first-folio.demo.lobb.ie)
2. Look at existing pages in the repo for reference - copying a working page and editing it is often the easiest approach
3. The [Hugo documentation](https://gohugo.io/documentation/) covers everything in detail
4. The [Hugo Discourse forum](https://discourse.gohugo.io/) is active and helpful
