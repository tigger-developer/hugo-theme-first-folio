# shellcheck shell=bash
# ABOUTME: RT-66.4 - nested audiobook src resolves relative to the page bundle.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page feed
    page="$(audiobook_fixture_page "audiobook-relative-resources")" || return 1
    feed="$(audiobook_fixture_feed "audiobook-relative-resources")" || return 1

    htmlq -f "$page" -a src 'audio source' | grep -qxF '/audiobook-demo/files/ch02.m4a' || return 1
    local url
    url="$(xmlstarlet sel -t -v '/rss/channel/item[guid = "relative-resource-audiobook:nested-resource"]/enclosure/@url' "$feed")"
    [[ "$url" == "https://fixture.example/audiobook-demo/files/ch02.m4a" ]]
}
