# shellcheck shell=bash
# ABOUTME: RT-79.5 - compiled card CSS uses one primary-accent attribution group at two sizes.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir stylesheet
    build_dir="$(review_fixture_dir)" || return 1
    stylesheet="$(find "$build_dir/css" -maxdepth 1 -type f -name 'main.*.css' -print -quit)"
    [[ -n "$stylesheet" ]] || return 1
    grep -qF '.review-listing-metadata--compact {' "$stylesheet" || return 1
    grep -qF '.review-listing-metadata--prominent {' "$stylesheet" || return 1
    [[ "$(grep -cF 'background: var(--color-primary);' "$stylesheet")" -ge 2 ]]
}
