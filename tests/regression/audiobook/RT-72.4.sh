# shellcheck shell=bash
# ABOUTME: RT-72.4 - rendered audio pages expose sleep timer controls.
# ABOUTME: The generated player includes minute, end-of-item, and cancel timer options.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(rt72_count "$page" '.audiobook-controls [data-audiobook-sleep-controls]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-sleep-toggle][aria-expanded="false"]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-sleep-status]')" -gt 0 ]] || return 1
    [[ "$(rt72_attr_count "$page" data-audiobook-sleep-minutes '[data-audiobook-sleep-minutes]')" == "4" ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-sleep-end]')" -gt 0 ]] || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-sleep-cancel]')" -gt 0 ]] || return 1
}
