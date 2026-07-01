# shellcheck shell=bash
# ABOUTME: RT-62.20 - noindex-enabled audiobook page includes robots metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local robots
    robots="$(htmlq -f "$page" -a content 'meta[name="robots"]')"
    [[ "$robots" == "noindex,nofollow,noarchive" ]]
}
