# shellcheck shell=bash
# ABOUTME: RT-62.23 - documentation covers metadata, feed output, copied audio, and player behaviour.

run_test() {
    local doc="$THEME_ROOT/docs/audiobook.md"
    [[ -f "$doc" ]] || return 1

    grep -qF 'Required metadata' "$doc" || return 1
    grep -qF 'Optional metadata' "$doc" || return 1
    grep -qF 'outputs:' "$doc" || return 1
    grep -qF 'copied into the repository' "$doc" || return 1
    grep -qF 'localStorage' "$doc" || return 1
}
