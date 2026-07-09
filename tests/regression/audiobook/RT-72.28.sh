# shellcheck shell=bash
# ABOUTME: RT-72.28 - media-session support is optional.
# ABOUTME: The rendered player has no dependency on a media-session-only element.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(rt72_count "$page" '.audiobook-player')" -gt 0 ]]
}
