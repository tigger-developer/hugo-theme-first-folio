# shellcheck shell=bash
# ABOUTME: RT-78.7 - hero and featured review metadata follows their media before article text.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local hero build_dir
    hero="$(review_page hero)" || return 1
    build_dir="$(review_example_dir)" || return 1
    [[ -z "$(htmlq -f "$hero" '.article-header .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$hero" '.article-header + .post-hero + .review-metadata')" ]] || return 1

    local -a featured_pages=(
        "$build_dir/book-reviews/book-featured/index.html"
        "$build_dir/game-reviews/game-featured/index.html"
    )
    local featured
    for featured in "${featured_pages[@]}"; do
        [[ -z "$(htmlq -f "$featured" '.article-header .review-metadata')" ]] || return 1
        [[ -n "$(htmlq -f "$featured" '.article-header + .post-featured + .review-metadata')" ]] || return 1
    done
}
