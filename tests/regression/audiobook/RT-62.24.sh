# shellcheck shell=bash
# ABOUTME: RT-62.24 - documentation demonstrates the minimal frontmatter shape.

run_test() {
    local doc="$THEME_ROOT/docs/audiobook.md"
    [[ -f "$doc" ]] || return 1

    grep -qF 'type: audiobook' "$doc" || return 1
    grep -qF 'params:' "$doc" || return 1
    grep -qF 'audiobook:' "$doc" || return 1
    grep -qF 'chapters:' "$doc" || return 1
}
