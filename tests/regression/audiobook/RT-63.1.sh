# shellcheck shell=bash
# ABOUTME: RT-63.1 - audio feed defaults to episodic podcast ordering metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_fixture_feed "audiobook-generated-media")" || return 1

    local type
    type="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/itunes:type' "$feed")"
    [[ "$type" == "episodic" ]]
}
