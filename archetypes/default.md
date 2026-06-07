---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
# pin: 0  # Pin to homepage grid top (0-99999, lower number = higher priority)
# hideDate: true  # Hide publication date on cards and article pages
# _build:  # Exclude from listings but keep page accessible via direct URL
#   list: false
# tags: ["tag1", "tag2", "tag3"]  # Article tags
# author: ""  # Article author
# description: ""  # Custom description for masonry cards (defaults to summary)
# layout: banner  # Image layout: banner (full-width + title overlay), hero (large below title), featured (content flows around), background (subtle + opacity/blur), columns (two-column), featured-columns-left (image left), featured-columns-right (image right)
# image:  # Image configuration for layout options above
#   src: "image.jpg"  # Path to image file in page bundle
#   alt: "Image description"  # Alt text for accessibility (defaults to caption, then title)
#   caption: "Image caption"  # Caption displayed below image (banner/hero layouts)
#   opacity: 0.7  # Image opacity (0.0-1.0, lower = darker/more transparent)
#   blur: 2px  # CSS blur effect applied to image
#   position: "center center"  # CSS object-position/background-position for cropping
#   size: "cover"  # CSS background-size for background layout
#   card_src: "card-crop.jpg"  # Alternative image for masonry cards (falls back to src)
#   card_position: "center top"  # CSS position for card image (falls back to position)
#   carousel_src: "wide.jpg"  # Alternative image for carousel cards (falls back to card_src, then src)
#   carousel_position: "center"  # CSS position for carousel image (falls back to card_position, then position)
#   wash:  # Background-layout wash overrides (per-page override of site params.wash)
#     opacity: 0.4  # Wash tint opacity
#     blur: 2px  # Backdrop blur behind text
#     gradient: "10% 20% 10% 20%"  # CSS gradient stops
#   banner_wash:  # Banner-layout wash overrides (per-page override of site params.banner.wash)
#     opacity: 0.4  # Wash tint opacity
#     blur: 3px  # Backdrop blur behind title
#     gradient: "25% 35% 25% 35%"  # CSS gradient stops
---
