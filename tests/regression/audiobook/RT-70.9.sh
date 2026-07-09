# shellcheck shell=bash
# ABOUTME: RT-70.9 - feed link and copy data are contained inside the disclosure.
# ABOUTME: The user can see and copy the feed link only from the subscription panel.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local feed_links
    feed_links="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel .audiobook-feed-link')"
    [[ "$feed_links" == "/podcast-demo/feed.xml" ]] || return 1

    local copy_values
    copy_values="$(htmlq -f "$page" -a data-copy-value '.audiobook-subscribe-panel [data-audio-assist-copy]')"
    [[ "$copy_values" == "https://example.com/podcast-demo/feed.xml" ]] || return 1

    local copy_feedback_count
    copy_feedback_count="$(htmlq -f "$page" '.audiobook-subscribe-panel [data-audio-assist-copied]' | wc -c | tr -d ' ')"
    [[ "$copy_feedback_count" -gt 0 ]] || return 1
}
