---
title: "About"
linkTitle: "Profile"
list_style: prose
description: "A consultancy / personal-practice landing page demo."
signpost:
  text: "TOP-CTA"
  url: /journal/
signpost_footer:
  text: "BOTTOM-CTA"
  url: /journal/
---

PROSE BODY MARKER

A landing page for a consultancy or personal-practice site. `list_style: prose` short-circuits the cards / carousel / pagination pipeline and renders just the `.Content` of `_index.md`, with the optional `signpost` and `signpost_footer` frontmatter rendered above and below.

Compose the page with whatever shortcodes you need inside the body — testimonials, stats, selected work — without forcing every site through the homepage grid.

{{< stats >}}
{{< stat number="40" label="Years experience" >}}
{{< stat number="80" label="Countries advised" >}}
{{< stat number="200" suffix="+" label="Parties advised" >}}
{{< /stats >}}

## What clients say

{{< quote name="A. Client" role="Director" organization="Example Co" featured=true >}}
Clarity where there was none.
{{< /quote >}}
