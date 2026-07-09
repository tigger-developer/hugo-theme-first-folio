# shellcheck shell=bash
# ABOUTME: RT-75.8 - audio docs publish label and numeric precedence.

run_test() {
    local docs="$THEME_ROOT/docs/audiobook.md"

    grep -qF 'label' "$docs" || return 1
    grep -qF 'Generated fallback labels use this precedence' "$docs"
}
