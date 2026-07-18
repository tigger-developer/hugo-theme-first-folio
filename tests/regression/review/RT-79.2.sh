# shellcheck shell=bash
# ABOUTME: RT-79.2 - carousel reviews retain section but omit article author and date.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_home_page)" || return 1
    [[ -n "$(htmlq -f "$page" '.carousel-card.masonry-cards .masonry-section')" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.carousel-card.masonry-cards .review-listing-metadata--prominent')" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.carousel-card.masonry-cards .review-listing-metadata--prominent + .masonry-meta')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.carousel-card.masonry-cards .masonry-author')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.carousel-card.masonry-cards .masonry-date')" ]]
}
