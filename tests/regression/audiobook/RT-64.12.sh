# shellcheck shell=bash
# ABOUTME: RT-64.12 - missing item dates fall back to the audiobook page date.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-generated-media")" || return 1

    local pub_date
    pub_date="$(xmlstarlet sel -t -v '/rss/channel/item[1]/pubDate' "$feed")"
    [[ "$pub_date" == "Thu, 04 Jul 2024 09:30:00 +0100" ]]
}
