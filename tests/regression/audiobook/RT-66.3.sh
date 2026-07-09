# shellcheck shell=bash
# ABOUTME: RT-66.3 - dot-relative audiobook src resolves to page-resource URL.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page feed
    page="$(audiobook_fixture_page "audiobook-relative-resources")" || return 1
    feed="$(audiobook_fixture_feed "audiobook-relative-resources")" || return 1

    htmlq -f "$page" -a data-chapter-src '.audiobook-track-button[data-chapter-id]' | grep -qxF '/audiobook-demo/ch01.m4a' || return 1
    local url
    url="$(xmlstarlet sel -t -v '/rss/channel/item[guid = "relative-resource-audiobook:dot-relative"]/enclosure/@url' "$feed")"
    [[ "$url" == "https://fixture.example/audiobook-demo/ch01.m4a" ]]
}
