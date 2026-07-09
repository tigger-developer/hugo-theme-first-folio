# shellcheck shell=bash
# ABOUTME: RT-72.34 - audio documentation exists for the enhanced metadata contract.
# ABOUTME: Human review owns prose quality; regression keeps the doc artefact present.

run_test() {
    [[ -s "$THEME_ROOT/docs/audiobook.md" ]]
}
