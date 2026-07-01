# shellcheck shell=bash
# ABOUTME: RT-62.8 - example site build contains audiobook podcast feed at documented path.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1
    [[ -f "$feed" ]]
}
