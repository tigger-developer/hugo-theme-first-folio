# shellcheck shell=bash
# ABOUTME: RT-78.40 - the delivered rating strip is not constrained by the theme's icon-sized SVG rule.
# ABOUTME: Readers receive a review-specific maximum-size reset in the built stylesheet.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local main_css
    main_css="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    [[ -n "$main_css" ]] || return 1

    local rating_rule
    rating_rule="$(grep -A 8 '^\.review-rating-strip {' "$main_css")"
    grep -qF 'max-inline-size: none;' <<< "$rating_rule" || return 1
    grep -qF 'max-block-size: none;' <<< "$rating_rule"
}
