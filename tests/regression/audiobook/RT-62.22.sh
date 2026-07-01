# shellcheck shell=bash
# ABOUTME: RT-62.22 - documentation states robots metadata is advisory.

run_test() {
    local doc="$THEME_ROOT/docs/audiobook.md"
    [[ -f "$doc" ]] || return 1

    grep -qF 'Robots metadata is advisory' "$doc" || return 1
    grep -qF 'robots.txt' "$doc" || return 1
    grep -qF 'access control' "$doc" || return 1
}
