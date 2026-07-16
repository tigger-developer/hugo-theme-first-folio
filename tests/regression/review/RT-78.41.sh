# shellcheck shell=bash
# ABOUTME: RT-78.41 - article headers stack title, breadcrumb, and review metadata in source order.
# ABOUTME: The delivered CSS isolates semantic article headers from the site-header flex rule.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local -a pages=(
        "$build_dir/book-reviews/book-banner/index.html"
        "$build_dir/book-reviews/the-glass-archive/index.html"
        "$build_dir/game-reviews/signal-at-dusk/index.html"
        "$build_dir/game-reviews/game-hero/index.html"
    )
    local page
    for page in "${pages[@]}"; do
        [[ -n "$(htmlq -f "$page" '.article-header > h1 + .meta + .review-metadata')" ]] || return 1
    done

    local main_css
    main_css="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    [[ -n "$main_css" ]] || return 1

    local header_rule
    header_rule="$(grep -A 6 '^\.article-header {' "$main_css")"
    grep -qF 'display: block;' <<< "$header_rule" || return 1
    grep -qF 'line-height: normal;' <<< "$header_rule"
}
