<!-- Version: 1.6 | Last updated: 2026-07-18 -->

# Review metadata

First Folio adds reviewed-item metadata to an ordinary article when its frontmatter contains a `review` map. Review metadata does not select a page layout: banner, background, hero, featured, and columns layouts remain available. An article without a layout continues to use the theme's image-free fallback.

Review metadata remains before article prose, but its exact position follows the selected presentation:

- Background and image-free articles place it in the article header after the title and breadcrumb/date.
- Banner articles retain the title and breadcrumb/date on the banner, then place review metadata immediately below the banner.
- Hero articles place it immediately below the hero media.
- Featured articles place it immediately after the floated media element, where it begins the surrounding text flow.
- Column articles retain a full-width title and breadcrumb/date, then place review metadata first in whichever column contains article text.

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
  review:
    attribution:
      en: by
      fr: de
  cardImage:
    showReview: true
  carousel:
    showReview: true
```

Plain-list metadata contains only the reviewed-item title and creator. When either card control is enabled, the section/topic remains visible while the article author and publication date are omitted. The reviewed-item title and optional creator appear together as a separate accent group: the title is bold, while the localized connector and creator are italic. A review without a creator shows its title without a connector.

Masonry uses compact meta sizing; carousel uses the same visual language at a larger size. The connector is selected from `params.review.attribution` using the page language, then the site language, then `en`; when none is configured, the built-in `by` is used. Artwork, ratings, and item-type role labels remain on the article page.

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
| Banner | [Please Do Not Feed the Footnotes](/book-reviews/book-banner/) | [Goose Tribunal 3000](/game-reviews/game-banner/) |
| Hero | [The Extremely Polite Volcano](/book-reviews/book-hero/) | [The Last Biscuit on Mars](/game-reviews/game-hero/) |
| Featured | [The Moon's Least Reliable Librarian](/book-reviews/book-featured/) | [Competitive Napping Championship](/game-reviews/game-featured/) |
| Background | [The Umbrella That Audited Tuesday](/book-reviews/book-background/) | [Wizard Tax Picnic](/game-reviews/signal-at-dusk/) |
| Columns, image left (`featured-columns-left`) | [Catalogue of Invisible Sandwiches](/book-reviews/the-glass-archive/) | [Dungeon Janitor: Mop of Destiny](/game-reviews/game-columns/) |
| Columns, image right (`featured-columns-right`) | [A Brief History of Competitive Moss](/book-reviews/book-columns-right/) | [Professor Turnip's Zero-G Laundrette](/game-reviews/game-columns-right/) |

Every demonstration includes a generated article image, separately generated reviewed-item cover art, and a rating. Article imagery and review artwork remain independent page-bundle resources.

## Changelog

- 1.6 (2026-07-18): Documented localized reviewed-item attribution on masonry and carousel cards, including retained section metadata and connector fallback.
- 1.5 (2026-07-17): Documented the final media-aware review placement for banner, hero, featured, and both column directions.
- 1.4 (2026-07-16): Replaced the demonstration identities and imagery with twelve distinct fictional works and twenty-four generated raster assets.
- 1.3 (2026-07-16): Added both image-left and image-right column demonstrations to each review section.
- 1.2 (2026-07-16): Expanded the demonstrations to one page for every image-based layout in both review sections and clarified the image-free fallback.
- 1.1 (2026-07-15): Documented review metadata, ratings, listing controls, and item-type customization.
