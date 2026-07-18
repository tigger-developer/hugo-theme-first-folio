# shellcheck shell=bash
# ABOUTME: RT-79.4 - card attribution resolves configured languages and the built-in fallback.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page fallback_dir fallback_page
    page="$(review_home_page)" || return 1
    [[ "$(htmlq -f "$page" -t '.card-review[data-review-title="Masonry Subject"] .review-listing-connector')" == "by" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.card-review[data-review-title="Carousel Subject"] .review-listing-connector')" == "de" ]] || return 1

    fallback_dir="$(build_fixture "review-attribution-fallback")" || return 1
    fallback_page="$fallback_dir/cards/index.html"
    [[ "$(htmlq -f "$fallback_page" -t '.review-listing-connector')" == "by" ]]
}
