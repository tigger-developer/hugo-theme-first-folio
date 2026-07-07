# shellcheck shell=bash
# ABOUTME: RT-66.7 - remote audiobook src is preserved in HTML and RSS.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page feed
    page="$(audiobook_fixture_page "audiobook-remote-frontmatter")" || return 1
    feed="$(audiobook_fixture_feed "audiobook-remote-frontmatter")" || return 1

    htmlq -f "$page" -a src 'audio source' | grep -qxF 'https://cdn.example.test/audio/episode-1.m4a' || return 1
    local url
    url="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@url' "$feed")"
    [[ "$url" == "https://cdn.example.test/audio/episode-1.m4a" ]]
}
