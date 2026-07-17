# shellcheck shell=bash
# ABOUTME: RT-78.41 - background and text-only headers stack their review metadata.
# ABOUTME: The delivered CSS isolates semantic article headers from the site-header flex rule.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_fixture_dir)" || return 1

    local -a pages=(
        "$build_dir/reviews/game/index.html"
        "$build_dir/reviews/text/index.html"
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
