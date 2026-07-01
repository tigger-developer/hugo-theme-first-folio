# shellcheck shell=bash
# ABOUTME: RT-62.7 - generated podcast feed uses copied repo-local demo audio URLs.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local enclosure_urls
    enclosure_urls="$(xmlstarlet sel -t -m '/rss/channel/item/enclosure' -v '@url' -n "$feed")"
    grep -qF 'https://example.com/audio/audiobook-demo/episode-1.m4a' <<< "$enclosure_urls" || return 1
    grep -qF 'https://example.com/audio/audiobook-demo/episode-2.m4a' <<< "$enclosure_urls" || return 1
    grep -qF 'https://example.com/audio/audiobook-demo/episode-3.m4a' <<< "$enclosure_urls" || return 1
}
