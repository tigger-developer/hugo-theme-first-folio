# shellcheck shell=bash
# ABOUTME: RT-78.32 - enabled masonry cards show review title and creator.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_cards_page)" || return 1
    [[ "$(htmlq -f "$page" -t '.masonry-item:not(.carousel-card) .card-review-title')" == "Masonry Subject" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.masonry-item:not(.carousel-card) .card-review-creator')" == "Masonry Creator" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-item:not(.carousel-card) .masonry-meta')" ]]
}
