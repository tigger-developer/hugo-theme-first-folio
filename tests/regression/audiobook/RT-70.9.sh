# shellcheck shell=bash
# ABOUTME: RT-70.9 - feed link and copy data are contained inside the disclosure.
# ABOUTME: The user can see and copy the feed link only from the subscription panel.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local feed_links
    feed_links="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel .audiobook-feed-link')"
    grep -qxF '/podcast-demo/feed.xml' <<< "$feed_links" || return 1

    local copy_values
    copy_values="$(htmlq -f "$page" -a data-copy-value '.audiobook-subscribe-panel [data-audio-assist-copy]')"
    grep -qxF 'https://example.com/podcast-demo/feed.xml' <<< "$copy_values" || return 1

    local copy_labels
    copy_labels="$(htmlq -f "$page" -a data-audio-assist-copied '.audiobook-subscribe-panel [data-audio-assist-copy]')"
    grep -qxF 'Copied Podcast Feed Link' <<< "$copy_labels" || return 1
}
