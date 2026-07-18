# shellcheck shell=bash
# ABOUTME: RT-79.1 - masonry review cards retain section but omit article author and date.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_home_page)" || return 1
    [[ -n "$(htmlq -f "$page" '.masonry-item.masonry-cards:not(.carousel-card) .masonry-section')" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.masonry-item.masonry-cards:not(.carousel-card) .review-listing-metadata--compact')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-item.masonry-cards:not(.carousel-card) .masonry-author')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-item.masonry-cards:not(.carousel-card) .masonry-date')" ]]
}
