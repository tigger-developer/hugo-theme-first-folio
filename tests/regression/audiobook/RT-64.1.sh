# shellcheck shell=bash
# ABOUTME: RT-64.1 - generated media metadata supplies RSS item duration.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-generated-media")" || return 1

    local duration
    duration="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/item[1]/itunes:duration' "$feed")"
    [[ "$duration" == "00:02:22" ]]
}
