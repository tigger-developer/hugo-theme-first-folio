# shellcheck shell=bash
# ABOUTME: RT-78.38 - the example site publishes one review for each rendered layout family.
# ABOUTME: The six demonstrations are shared across book and game review sections without duplication.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a book_links
    local -a game_links
    mapfile -t book_links < <(htmlq -f "$build_dir/book-reviews/index.html" -a href '.list-view-title a')
    mapfile -t game_links < <(htmlq -f "$build_dir/game-reviews/index.html" -a href 'a' | grep '^/game-reviews/[^/][^/]*/$' | sort -u)

    [[ ${#book_links[@]} -eq 3 ]] || return 1
    [[ ${#game_links[@]} -eq 3 ]] || return 1

    [[ -n "$(htmlq -f "$build_dir/book-reviews/the-glass-archive/index.html" '.columns-layout .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-banner/index.html" '.post-banner .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-featured/index.html" '.post-featured')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-featured/index.html" '.review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/signal-at-dusk/index.html" '.post-container.dark-bg .review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-hero/index.html" '.post-hero')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-hero/index.html" '.review-metadata--game')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/game-reviews/game-text/index.html" '.review-metadata--game')" ]]
}
