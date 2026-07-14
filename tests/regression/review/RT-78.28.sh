# shellcheck shell=bash
# ABOUTME: RT-78.28 - example sections retain distinct Hugo content types.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir book game
    build_dir="$(review_example_dir)" || return 1
    book="$build_dir/book-reviews/the-glass-archive/index.html"
    game="$build_dir/game-reviews/signal-at-dusk/index.html"
    [[ "$(htmlq -f "$book" -a data-content-type '.review-metadata')" == "book-reviews" ]] || return 1
    [[ "$(htmlq -f "$game" -a data-content-type '.review-metadata')" == "game-reviews" ]]
}
