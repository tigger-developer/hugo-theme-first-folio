# shellcheck shell=bash
# ABOUTME: RT-63.1 - audiobook feed defaults to serial podcast ordering metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local type
    type="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v '/rss/channel/itunes:type' "$feed")"
    [[ "$type" == "serial" ]]
}
