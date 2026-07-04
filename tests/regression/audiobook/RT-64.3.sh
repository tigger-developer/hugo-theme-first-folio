# shellcheck shell=bash
# ABOUTME: RT-64.3 - generated media facts override front matter facts.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-generated-media")" || return 1

    local length duration
    length="$(xmlstarlet sel -t -v '/rss/channel/item[1]/enclosure/@length' "$feed")"
    duration="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/item[1]/itunes:duration' "$feed")"

    [[ "$length" == "222" ]] || return 1
    [[ "$duration" == "00:02:22" ]]
}
