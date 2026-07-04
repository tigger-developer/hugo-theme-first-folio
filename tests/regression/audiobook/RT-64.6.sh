# shellcheck shell=bash
# ABOUTME: RT-64.6 - remote media can use manual front matter enclosure length.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-remote-frontmatter")" || return 1

    local enclosure_url length
    enclosure_url="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@url' "$feed")"
    length="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@length' "$feed")"

    [[ "$enclosure_url" == "https://cdn.example.test/audio/episode-1.m4a" ]] || return 1
    [[ "$length" == "98765" ]]
}
