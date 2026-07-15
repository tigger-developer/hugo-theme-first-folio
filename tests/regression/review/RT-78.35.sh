# shellcheck shell=bash
# ABOUTME: RT-78.35 - masonry and carousel reviews expose distinct presentation classes.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_cards_page)" || return 1
    [[ -n "$(htmlq -f "$page" '.masonry-item:not(.carousel-card) .review-listing-metadata--compact')" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.carousel-card .review-listing-metadata--prominent')" ]]
}
