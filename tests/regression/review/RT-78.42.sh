# shellcheck shell=bash
# ABOUTME: RT-78.42 - book reviews demonstrate every visually distinct image-based presentation once.
# ABOUTME: The section includes both left- and right-image column layouts.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a links
    mapfile -t links < <(htmlq -f "$build_dir/book-reviews/index.html" -a href '.list-view-title a')
    [[ ${#links[@]} -eq 6 ]] || return 1

    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-banner/index.html" '.banner-content > .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-hero/index.html" '.post-hero')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-featured/index.html" '.post-featured')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-background/index.html" '.post-container.dark-bg .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/the-glass-archive/index.html" '.post-featured-columns > .featured-image-col:first-child')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-columns-right/index.html" '.post-featured-columns > .featured-text-col:first-child')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-columns-right/index.html" '.columns-layout .review-metadata--book')" ]]
}
