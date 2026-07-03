# shellcheck shell=bash
# ABOUTME: RT-63.2 - audiobook feed emits configured episode numbers for chapters.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local episodes
    episodes="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -m '/rss/channel/item' -v 'itunes:episode' -n "$feed")"
    [[ "$episodes" == $'1\n2\n3' ]]
}
