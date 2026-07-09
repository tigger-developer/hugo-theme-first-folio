# shellcheck shell=bash
# ABOUTME: RT-72.1 - rendered audio pages expose playback speed controls.
# ABOUTME: The generated player includes accessible speed presets.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-speed-controls]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '.audiobook-controls [data-audiobook-speed-controls]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-speed-toggle][aria-expanded="false"]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-speed-status]')" -gt 0 ]] || return 1
    [[ "$(rt72_attr_count "$page" data-audiobook-speed '[data-audiobook-speed]')" == "5" ]] || return 1
}
