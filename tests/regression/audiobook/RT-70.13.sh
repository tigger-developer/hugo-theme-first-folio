# shellcheck shell=bash
# ABOUTME: RT-70.13 - Home Screen guidance and install metadata render when enabled.
# ABOUTME: The generated page carries manifest and icon hints for save-to-device flows.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local panel_count
    panel_count="$(htmlq -f "$page" -t '.audiobook-homescreen-panel[open] summary' | wc -l | tr -d ' ')"
    [[ "$panel_count" == "1" ]] || return 1

    local summary_count
    summary_count="$(htmlq -f "$page" '.audiobook-homescreen-panel summary' | wc -c | tr -d ' ')"
    [[ "$summary_count" -gt 0 ]] || return 1

    local share_button_count generic_instruction_count
    share_button_count="$(htmlq -f "$page" '.audiobook-homescreen-panel [data-audio-web-share][data-share-url]' | wc -c | tr -d ' ')"
    generic_instruction_count="$(htmlq -f "$page" '.audiobook-homescreen-panel [data-homescreen-instruction="generic"]' | wc -c | tr -d ' ')"
    [[ "$share_button_count" -gt 0 ]] || return 1
    [[ "$generic_instruction_count" == "0" ]] || return 1

    local manifest_href
    manifest_href="$(htmlq -f "$page" -a href 'link[rel="manifest"]')"
    [[ "$manifest_href" == "/audiobook-demo/manifest.webmanifest" ]] || return 1

    local icon_href
    icon_href="$(htmlq -f "$page" -a href 'link[rel="apple-touch-icon"]')"
    [[ "$icon_href" == "/audiobook-demo/beacon3.jpg" ]] || return 1
}
