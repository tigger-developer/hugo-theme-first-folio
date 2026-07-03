# shellcheck shell=bash
# ABOUTME: RT-63.3 - podcast feed preserves configured chapter order.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local titles
    titles="$(xmlstarlet sel -t -m '/rss/channel/item' -v 'title' -n "$feed")"
    [[ "$titles" == $'Demo Episode 1\nDemo Episode 2\nDemo Episode 3' ]]
}
