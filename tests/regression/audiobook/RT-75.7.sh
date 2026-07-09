# shellcheck shell=bash
# ABOUTME: RT-75.7 - audio docs publish the label-only display contract.

run_test() {
    local docs="$THEME_ROOT/docs/audiobook.md"

    grep -qF 'label' "$docs" || return 1
    grep -qF 'The theme does not invent numeric labels' "$docs"
}
