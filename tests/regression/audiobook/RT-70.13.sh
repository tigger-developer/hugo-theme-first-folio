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

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-homescreen-panel summary' | tr -d '\n')"
    [[ "$summary_text" == "Save to your Home Screen" ]] || return 1

    local panel_text
    panel_text="$(htmlq -f "$page" -t '.audiobook-homescreen-panel')"
    grep -qF "Use your browser's Share or menu button to add this page to your phone." <<< "$panel_text" || return 1

    local manifest_href
    manifest_href="$(htmlq -f "$page" -a href 'link[rel="manifest"]')"
    grep -qxF '/audiobook-demo/manifest.webmanifest' <<< "$manifest_href" || return 1

    local icon_href
    icon_href="$(htmlq -f "$page" -a href 'link[rel="apple-touch-icon"]')"
    grep -qxF '/audiobook-demo/beacon3.jpg' <<< "$icon_href" || return 1
}
