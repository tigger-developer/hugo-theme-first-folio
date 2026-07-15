# shellcheck shell=bash
# ABOUTME: RT-78.34 - enabled carousel cards show review title and creator.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_cards_page)" || return 1
    [[ "$(htmlq -f "$page" -t '.carousel-card .card-review-title')" == "Carousel Subject" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.carousel-card .card-review-creator')" == "Carousel Creator" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.carousel-card .masonry-meta')" ]]
}
