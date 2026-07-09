# shellcheck shell=bash
# ABOUTME: RT-63.2 - podcast feed does not invent episode numbers.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(podcast_demo_feed)" || return 1

    local episode_count
    episode_count="$(xmlstarlet sel -N itunes='http://www.itunes.com/dtds/podcast-1.0.dtd' -t -v 'count(/rss/channel/item/itunes:episode)' "$feed")"
    [[ "$episode_count" == "0" ]]
}
