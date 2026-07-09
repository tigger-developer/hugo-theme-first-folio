# shellcheck shell=bash
# ABOUTME: RT-75.7 - audio docs publish the startNumber/displayNumber contract.

run_test() {
    local docs="$THEME_ROOT/docs/audiobook.md"

    grep -qF 'startNumber' "$docs" || return 1
    grep -qF 'displayNumber' "$docs"
}
