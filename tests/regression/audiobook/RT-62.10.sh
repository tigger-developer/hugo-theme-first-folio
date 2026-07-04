# shellcheck shell=bash
# ABOUTME: RT-62.10 - every feed item has an absolute enclosure URL, MIME type, and byte length.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local feed
    feed="$(audiobook_demo_feed)" || return 1

    local valid_count
    valid_count="$(xmlstarlet sel -t -v 'count(/rss/channel/item/enclosure[(starts-with(@url, "https://") or starts-with(@url, "http://")) and contains(@url, "/audio/audiobook-demo/") and @type = "audio/mp4" and number(@length) > 0])' "$feed")"
    [[ "$valid_count" == "7" ]]
}
