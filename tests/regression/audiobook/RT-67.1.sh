# shellcheck shell=bash
# ABOUTME: RT-67.1 - audio pages expose default feed subscription controls.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local feed_links
    feed_links="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel .audiobook-feed-link')"
    [[ "$feed_links" == "/podcast-demo/feed.xml" ]] || return 1

    local copy_urls
    copy_urls="$(htmlq -f "$page" -a data-copy-value '.audiobook-subscribe-panel [data-audio-assist-copy]')"
    [[ "$copy_urls" == "https://example.com/podcast-demo/feed.xml" ]] || return 1

    local copy_count
    copy_count="$(htmlq -f "$page" '.audiobook-subscribe-panel .audiobook-copy-button[aria-label]' | wc -c | tr -d ' ')"
    [[ "$copy_count" -gt 0 ]] || return 1

    local summary_count
    summary_count="$(htmlq -f "$page" '.audiobook-subscribe-panel summary' | wc -c | tr -d ' ')"
    [[ "$summary_count" -gt 0 ]] || return 1

    local prompt_count hint_count
    prompt_count="$(htmlq -f "$page" '.audiobook-subscribe-panel .audiobook-subscribe-prompt' | wc -c | tr -d ' ')"
    hint_count="$(htmlq -f "$page" '.audiobook-subscribe-panel .audiobook-subscribe-hint' | wc -c | tr -d ' ')"
    [[ "$prompt_count" -gt 0 ]] || return 1
    [[ "$hint_count" -gt 0 ]] || return 1

    local link_count
    link_count="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel a' | wc -l | tr -d ' ')"
    [[ "$link_count" == "1" ]]
}
