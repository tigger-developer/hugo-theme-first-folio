# shellcheck shell=bash
# ABOUTME: RT-70.16 - audio documentation is present for the theme-owned feature.
# ABOUTME: Documentation content is reviewed by humans rather than wording assertions.

run_test() {
    local doc="$THEME_ROOT/docs/audiobook.md"

    [[ -s "$doc" ]]
}
