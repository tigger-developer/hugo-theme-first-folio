# shellcheck shell=bash
# ABOUTME: RT-75.8 - audio docs keep generated metadata scoped to media facts.

run_test() {
    local docs="$THEME_ROOT/docs/audiobook.md"

    grep -qF 'Generated media metadata should contain media facts' "$docs" || return 1
    grep -qF 'Generated media metadata should not contain editorial labels' "$docs"
}
