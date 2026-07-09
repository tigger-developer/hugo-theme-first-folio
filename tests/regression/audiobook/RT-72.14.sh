# shellcheck shell=bash
# ABOUTME: RT-72.14 - per-item restart controls are present.
# ABOUTME: Item rows expose a start-from-beginning action.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(rt72_count "$page" '.audiobook-track-actions summary')" -gt 0 ]] || return 1
    rt72_jxa resume
}
