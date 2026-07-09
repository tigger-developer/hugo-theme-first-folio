# shellcheck shell=bash
# ABOUTME: RT-70.12 - page share/save panel exposes page-link copy metadata.
# ABOUTME: Web Share is represented as progressive enhancement metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local panel_count
    panel_count="$(htmlq -f "$page" -t '.audiobook-save-panel summary' | wc -l | tr -d ' ')"
    [[ "$panel_count" == "1" ]] || return 1

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-save-panel summary' | tr -d '\n')"
    [[ "$summary_text" == "Share or save this page" ]] || return 1

    local copy_values
    copy_values="$(htmlq -f "$page" -a data-copy-value '.audiobook-save-panel [data-audio-assist-copy]')"
    grep -qxF 'https://example.com/audiobook-demo/' <<< "$copy_values" || return 1

    [[ "$(htmlq -f "$page" '.audiobook-save-panel [data-audio-web-share]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
}
