# shellcheck shell=bash
# ABOUTME: Shared JXA runner for RT-72 audio player behaviour tests.
# ABOUTME: Keeps JavaScript behaviour coverage Node-free for this Hugo theme.

rt72_jxa() {
    local scenario="$1"
    osascript -l JavaScript "$THEME_ROOT/tests/regression/audiobook/_rt72_player_scenarios.js" "$scenario"
}
