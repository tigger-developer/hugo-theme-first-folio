# shellcheck shell=bash
# ABOUTME: RT-78.43 - game reviews demonstrate every visually distinct image-based presentation once.
# ABOUTME: The section includes both left- and right-image column layouts without text-only.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a links
    mapfile -t links < <(htmlq -f "$build_dir/game-reviews/index.html" -a href 'a' | grep '^/game-reviews/[^/][^/]*/$' | sort -u)
    [[ ${#links[@]} -eq 6 ]] || return 1

    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-banner/index.html" '.banner-content > .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-hero/index.html" '.post-hero')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-featured/index.html" '.post-featured')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/signal-at-dusk/index.html" '.post-container.dark-bg .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns/index.html" '.post-featured-columns > .featured-image-col:first-child')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns-right/index.html" '.post-featured-columns > .featured-text-col:first-child')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-columns-right/index.html" '.columns-layout .review-metadata--game')" ]] || return 1
    [[ ! -e "$build_dir/game-reviews/game-text/index.html" ]]
}
