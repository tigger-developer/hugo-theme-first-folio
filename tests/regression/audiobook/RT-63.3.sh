# shellcheck shell=bash
# ABOUTME: RT-63.3 - audio feeds preserve configured item order.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local audiobook_feed podcast_feed
    audiobook_feed="$(audiobook_demo_feed)" || return 1
    podcast_feed="$(podcast_demo_feed)" || return 1

    local audiobook_titles podcast_titles
    audiobook_titles="$(xmlstarlet sel -t -m '/rss/channel/item' -v 'title' -n "$audiobook_feed")"
    podcast_titles="$(xmlstarlet sel -t -m '/rss/channel/item' -v 'title' -n "$podcast_feed")"

    [[ "$audiobook_titles" == $'Front Matter\nDemo Chapter 1\nDemo Chapter 2\nDemo Chapter 3\nDemo Chapter 4\nDemo Chapter 5\nDemo Chapter 6' ]] || return 1
    [[ "$podcast_titles" == $'Demo Episode 1\nDemo Episode 2\nDemo Episode 3' ]]
}
