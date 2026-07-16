# shellcheck shell=bash
# ABOUTME: RT-78.44 - all four column review demonstrations retain article media.
# ABOUTME: Rendered left- and right-image columns expose their generated article images.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a column_pages=(
        "$build_dir/book-reviews/the-glass-archive/index.html"
        "$build_dir/book-reviews/book-columns-right/index.html"
        "$build_dir/game-reviews/game-columns/index.html"
        "$build_dir/game-reviews/game-columns-right/index.html"
    )
    local column_page
    for column_page in "${column_pages[@]}"; do
        [[ "$(htmlq -f "$column_page" -a src '.featured-image-col img')" == */article.jpg ]] || return 1
    done
}
