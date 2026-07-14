# shellcheck shell=bash
# ABOUTME: RT-78.26 - example book reviews combine columns artwork and decimal scores.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir page
    build_dir="$(review_example_dir)" || return 1
    page="$build_dir/book-reviews/the-glass-archive/index.html"
    [[ "$(htmlq -f "$page" '.columns-layout .review-metadata--book' | grep -c 'review-metadata')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" -t '.review-rating-value')" == "4.9/5" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.review-artwork')" ]]
}
