# shellcheck shell=bash
# ABOUTME: RT-78.27 - example game reviews combine backgrounds no artwork and ten-point scores.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir page
    build_dir="$(review_example_dir)" || return 1
    page="$build_dir/game-reviews/signal-at-dusk/index.html"
    [[ "$(htmlq -f "$page" '.post-container.dark-bg .review-metadata--game' | grep -c 'review-metadata')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" -t '.review-rating-value')" == "8/10" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.review-artwork')" ]]
}
