# shellcheck shell=bash
# ABOUTME: RT-62.11 - feed channel contains required podcast metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local title description link language explicit
    title="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/title' "$feed")"
    description="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/description' "$feed")"
    link="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/link' "$feed")"
    language="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/language' "$feed")"
    explicit="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/itunes:explicit' "$feed")"

    [[ "$title" == "First Folio Demo Podcast" ]] || return 1
    [[ -n "$description" ]] || return 1
    [[ "$link" == "https://example.com/audiobook-demo/" ]] || return 1
    [[ "$language" == "en-GB" ]] || return 1
    [[ "$explicit" == "false" ]]
}
