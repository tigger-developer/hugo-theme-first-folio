# shellcheck shell=bash
# ABOUTME: RT-68.1 - serial feed fallback dates increment by chapter order.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-serial-fallback-dates")" || return 1

    local pub_dates
    pub_dates="$(xmlstarlet sel -t -m '/rss/channel/item' -v 'pubDate' -n "$feed")"
    [[ "$pub_dates" == $'Thu, 04 Jul 2024 09:30:00 +0100\nThu, 04 Jul 2024 09:30:01 +0100\nThu, 04 Jul 2024 09:30:02 +0100' ]]
}
