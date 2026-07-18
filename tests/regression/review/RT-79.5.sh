# shellcheck shell=bash
# ABOUTME: RT-79.5 - compiled card CSS uses one primary-accent attribution group at two sizes.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir stylesheet compact_rule prominent_rule accent_rule
    build_dir="$(review_fixture_dir)" || return 1
    stylesheet="$(find "$build_dir/css" -maxdepth 1 -type f -name 'main.*.css' -print -quit)"
    [[ -n "$stylesheet" ]] || return 1
    grep -qF '.review-listing-metadata--compact {' "$stylesheet" || return 1
    grep -qF '.review-listing-metadata--prominent {' "$stylesheet" || return 1
    compact_rule="$(sed -n '/^\.review-listing-metadata--compact {$/,/^}$/p' "$stylesheet")"
    prominent_rule="$(sed -n '/^\.review-listing-metadata--prominent {$/,/^}$/p' "$stylesheet")"
    accent_rule="$(sed -n '/^\.review-listing-accent {$/,/^}$/p' "$stylesheet")"
    [[ "$compact_rule" != *'background:'* ]] || return 1
    [[ "$prominent_rule" != *'background:'* ]] || return 1
    [[ "$accent_rule" == *'background: var(--color-primary);'* ]] || return 1
    [[ "$accent_rule" == *'box-decoration-break: clone;'* ]]
}
