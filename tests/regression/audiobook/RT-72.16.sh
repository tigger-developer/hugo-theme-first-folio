# shellcheck shell=bash
# ABOUTME: RT-72.16 - rendered audio pages expose up-next context.
# ABOUTME: The generated player includes an associated up-next region.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(rt72_count "$page" '[data-audiobook-up-next]')" -gt 0 ]]
}
