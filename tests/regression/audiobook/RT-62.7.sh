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

    start_examplesite_server 46814 || return 1
    trap stop_examplesite_server RETURN

    local path
    for path in /audio/audiobook-demo/episode-1.m4a /audio/audiobook-demo/episode-2.m4a /audio/audiobook-demo/episode-3.m4a; do
        local status
        status="$(http_status "$EXAMPLESITE_SERVER_URL$path")"
        if [[ "$status" != "200" ]]; then
            printf '    expected feed enclosure path %s to resolve over HTTP, got %s\n' "$path" "$status" >&2
            return 1
        fi
    done
}
