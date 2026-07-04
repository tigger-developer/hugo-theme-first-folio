# shellcheck shell=bash
# ABOUTME: RT-62.9 - podcast feed contains one item per configured chapter.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local count
    count="$(feed_item_count "$feed")"
    [[ "$count" == "7" ]]
}
