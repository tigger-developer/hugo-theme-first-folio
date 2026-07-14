# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #77 per-page masonry opacity regressions.
# ABOUTME: Builds the consuming-site fixture through Hugo's public boundary.

card_opacity_fixture() {
    build_fixture "card-opacity"
}
