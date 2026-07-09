# shellcheck shell=bash
# ABOUTME: RT-72.35 - audio documentation exists for player shortcut limitations.
# ABOUTME: Human review owns prose quality; regression keeps the doc artefact present.

run_test() {
    [[ -s "$THEME_ROOT/docs/audiobook.md" ]]
}
