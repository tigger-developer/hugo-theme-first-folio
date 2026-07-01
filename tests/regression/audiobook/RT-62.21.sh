# shellcheck shell=bash
# ABOUTME: RT-62.21 - audiobook page without noindex omits audiobook-specific robots metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page audiobook-noindex-disabled)" || return 1

    local robots
    robots="$(htmlq -f "$page" -a content 'meta[name="robots"]')"
    [[ -z "$robots" ]]
}
