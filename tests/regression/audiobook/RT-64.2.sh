# shellcheck shell=bash
# ABOUTME: RT-64.2 - local static audio file size supplies RSS enclosure length.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-local-stat")" || return 1

    local length
    length="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@length' "$feed")"
    [[ "$length" == "25" ]]
}
