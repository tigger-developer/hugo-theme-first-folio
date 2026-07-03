# shellcheck shell=bash
# ABOUTME: RT-63.4 - explicit episodic audiobook type is emitted in the feed.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-episodic-type")" || return 1

    local type
    type="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/itunes:type' "$feed")"
    [[ "$type" == "episodic" ]]
}
