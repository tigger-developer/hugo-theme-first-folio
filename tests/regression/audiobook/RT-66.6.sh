# shellcheck shell=bash
# ABOUTME: RT-66.6 - root-relative audiobook src remains a valid explicit site path.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page feed
    page="$(audiobook_fixture_page "audiobook-local-stat")" || return 1
    feed="$(audiobook_fixture_feed "audiobook-local-stat")" || return 1

    htmlq -f "$page" -a src 'audio source' | grep -qxF '/audio/audiobook-demo/episode-1.m4a' || return 1
    local url
    url="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@url' "$feed")"
    [[ "$url" == "https://fixture.example/audio/audiobook-demo/episode-1.m4a" ]]
}
