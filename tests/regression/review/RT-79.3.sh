# shellcheck shell=bash
# ABOUTME: RT-79.3 - card attribution is semantic and omits its byline without a creator.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_home_page)" || return 1
    [[ "$(htmlq -f "$page" -t '.card-review[data-review-title="Masonry Subject"] > strong.card-review-title')" == "Masonry Subject" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.card-review[data-review-title="Masonry Subject"] > em.review-listing-attribution .card-review-creator')" == "Masonry Creator" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.card-review[data-review-title="Creatorless Subject"] > strong.card-review-title')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.card-review[data-review-title="Creatorless Subject"] .review-listing-attribution')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.card-review[data-review-title="Creatorless Subject"] .review-listing-connector')" ]]
}
