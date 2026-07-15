# shellcheck shell=bash
# ABOUTME: RT-78.36 - book reviews demonstrate every standard article presentation.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-text/index.html" '.review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-banner/index.html" '.post-banner .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-hero/index.html" '.post-hero')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-featured/index.html" '.post-featured')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-background/index.html" '.post-container.dark-bg .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-columns/index.html" '.columns-layout .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/the-glass-archive/index.html" '.columns-layout .review-metadata--book')" ]] || return 1
    [[ -n "$(htmlq -f "$build_dir/book-reviews/book-columns-right/index.html" '.columns-layout .review-metadata--book')" ]]
}
