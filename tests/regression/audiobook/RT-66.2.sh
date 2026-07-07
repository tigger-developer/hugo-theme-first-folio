# shellcheck shell=bash
# ABOUTME: RT-66.2 - same-bundle audiobook src resolves to page-resource URL in RSS.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-relative-resources")" || return 1

    local url
    url="$(xmlstarlet sel -t -v '/rss/channel/item[guid = "relative-resource-audiobook:same-bundle"]/enclosure/@url' "$feed")"
    [[ "$url" == "https://fixture.example/audiobook-demo/ch00.m4a" ]]
}
