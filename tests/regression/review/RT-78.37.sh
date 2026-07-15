# shellcheck shell=bash
# ABOUTME: RT-78.37 - game reviews demonstrate every standard article presentation.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-text/index.html" '.review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-banner/index.html" '.post-banner .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-hero/index.html" '.post-hero')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-featured/index.html" '.post-featured')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/signal-at-dusk/index.html" '.post-container.dark-bg .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns/index.html" '.columns-layout .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns-left/index.html" '.columns-layout .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns-right/index.html" '.columns-layout .review-metadata--game')" ]]
}
