# shellcheck shell=bash
# ABOUTME: RT-66.9 - relative page resource supplies RSS enclosure length.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-relative-resources")" || return 1

    local length
    length="$(xmlstarlet sel -t -v '/rss/channel/item[guid = "relative-resource-audiobook:same-bundle"]/enclosure/@length' "$feed")"
    [[ "$length" == "18" ]]
}
