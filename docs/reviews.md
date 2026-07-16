<!-- Version: 1.3 | Last updated: 2026-07-16 -->

# Review metadata

First Folio adds reviewed-item metadata to an ordinary article when its frontmatter contains a `review` map. Review metadata does not select a page layout: banner, background, hero, featured, and columns layouts remain available. An article without a layout continues to use the theme's image-free fallback.

The article header is ordered as article title, breadcrumb/date, then reviewed item. The article body follows. In a banner layout the complete header remains on the banner surface.

## Frontmatter

```yaml
layout: featured-columns-left
review:
  itemType: book
  title: "The Left Hand of Darkness"
  creator: "Ursula K. Le Guin"
  artwork:
    src: cover.jpg
    alt: "Book cover"
  rating:
    value: 4.9
    scale: 5
```

Only `review.title` is required.

| Field | Required | Description |
|---|---|---|
| `review.title` | yes | Title of the reviewed work. |
| `review.creator` | no | Creator of the reviewed work. This is separate from the article's `author`. |
| `review.itemType` | no | Lowercase slug selecting an optional presentation partial, such as `book` or `game`. |
| `review.artwork.src` | no | Image resource within the page bundle. |
| `review.artwork.alt` | no | Alternative text. Defaults to `review.title`. |
| `review.rating.value` | when `rating` exists | Numeric score between zero and the resolved scale. Decimals are accepted. |
| `review.rating.scale` | no | Denominator for this review. Falls back to the site default, then `5`. |

Artwork and ratings are independent and optional. An unresolved artwork resource, malformed item type, missing title, or invalid rating stops the Hugo build with the page and field identified.

## Continuous ratings

The visual rating is a horizontal image strip clipped to `value / scale`. Thus `8/10` and `4/5` both fill 80%, while `4.9/5` fills 98%. The authored numeric value remains visible and is the accessible rating; the image strip is decorative.

Configure site defaults in `hugo.yaml`:

```yaml
params:
  review:
    rating:
      scale: 5
      image: /images/review-rating-stars.svg
```

The theme supplies a five-star image. A replacement should be a horizontal strip with the complete arrangement already evenly spaced.

## Lists and cards

Plain `list_style: list` entries show the reviewed-item title and optional creator whenever `review` exists. Masonry and carousel cards are opt-in and independent:

```yaml
params:
  cardImage:
    showReview: true
  carousel:
    showReview: true
```

Plain-list metadata contains only the reviewed-item title and creator. When either card control is enabled, that review identity replaces the card's ordinary section, article-author, and date metadata rather than adding another row. Masonry uses compact meta-sized pills; carousel uses the same visual language at a larger size. Artwork, ratings, and item-type role labels remain on the article page.

## Item types and Hugo content types

The theme includes `book` and `game` item partials, which label creators as `Author` and `Developer`. An omitted or unknown `itemType` uses the generic presentation without assuming a creator role.

A downstream project may add:

```text
layouts/partials/review/item-types/film.html
```

The partial receives normalized `Page`, `ItemType`, `Title`, `Creator`, `Artwork`, and `Rating` keys. Item types customize presentation only; they do not change validation or the data shape.

`review.itemType` is not Hugo's top-level `type`. Use sections to organize content such as `book-reviews` and `game-reviews`; use top-level `type` only when multiple sections need the same Hugo template behaviour. Moving an article between sections does not disable its review component.

Likewise, article `image` and `review.artwork` are separate. A background-layout game review may use an article background while omitting reviewed-item artwork.

## Demonstrations

The example site demonstrates every image-based article-layout family for both built-in item types. This shows that review metadata remains independent of both layout and item type:

| Presentation | Book review | Game review |
|---|---|---|
| Banner | [Book banner](/book-reviews/book-banner/) | [Game banner](/game-reviews/game-banner/) |
| Hero | [Book hero](/book-reviews/book-hero/) | [Game hero](/game-reviews/game-hero/) |
| Featured | [Book featured](/book-reviews/book-featured/) | [Game featured](/game-reviews/game-featured/) |
| Background | [Book background](/book-reviews/book-background/) | [Signal at Dusk](/game-reviews/signal-at-dusk/) |
| Columns, image left (`featured-columns-left`) | [The Glass Archive](/book-reviews/the-glass-archive/) | [Game columns left](/game-reviews/game-columns/) |
| Columns, image right (`featured-columns-right`) | [Book columns right](/book-reviews/book-columns-right/) | [Game columns right](/game-reviews/game-columns-right/) |

Every demonstration includes reviewed-item artwork and a rating except `Signal at Dusk`, which deliberately omits reviewed-item artwork to demonstrate that it remains optional and separate from the article background.

## Changelog

- 1.3 (2026-07-16): Added both image-left and image-right column demonstrations to each review section.
- 1.2 (2026-07-16): Expanded the demonstrations to one page for every image-based layout in both review sections and clarified the image-free fallback.
- 1.1 (2026-07-15): Documented review metadata, ratings, listing controls, and item-type customization.
