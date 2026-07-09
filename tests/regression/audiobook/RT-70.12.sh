# shellcheck shell=bash
# ABOUTME: RT-70.12 - Home Screen panel carries progressive Web Share metadata.
# ABOUTME: Weak standalone page-copy guidance is not rendered as a separate panel.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    [[ "$(htmlq -f "$page" '.audiobook-save-panel' | wc -c | tr -d ' ')" == "0" ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-homescreen-panel[open]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-homescreen-panel [data-audio-web-share]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
}
