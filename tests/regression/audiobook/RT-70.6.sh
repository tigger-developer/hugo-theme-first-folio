# shellcheck shell=bash
# ABOUTME: RT-70.6 - feed setup controls live inside a sidebar disclosure.
# ABOUTME: The rendered page keeps subscription help secondary to the player.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local panel_count
    panel_count="$(htmlq -f "$page" -t '.audiobook-sidebar details.audiobook-subscribe-panel summary' | wc -l | tr -d ' ')"
    [[ "$panel_count" == "1" ]] || return 1

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-sidebar details.audiobook-subscribe-panel summary' | tr -d '\n')"
    [[ "$summary_text" == "Listen in your favourite podcast app" ]] || return 1
}
