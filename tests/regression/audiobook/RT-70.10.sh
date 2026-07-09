# shellcheck shell=bash
# ABOUTME: RT-70.10 - feed setup renders compact structure without app-link clutter.
# ABOUTME: The panel exposes one feed link, one copy target, and no default footnote.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local panel_count
    panel_count="$(htmlq -f "$page" -t '.audiobook-subscribe-panel summary' | wc -l | tr -d ' ')"
    [[ "$panel_count" == "1" ]] || return 1

    local feed_link_count copy_target_count footnote_count
    feed_link_count="$(htmlq -f "$page" '.audiobook-subscribe-panel .audiobook-feed-link' | wc -c | tr -d ' ')"
    copy_target_count="$(htmlq -f "$page" '.audiobook-subscribe-panel [data-audio-assist-copy][data-copy-value]' | wc -c | tr -d ' ')"
    footnote_count="$(htmlq -f "$page" '.audiobook-subscribe-panel .audiobook-assist-footnote' | wc -c | tr -d ' ')"

    [[ "$feed_link_count" -gt 0 ]] || return 1
    [[ "$copy_target_count" -gt 0 ]] || return 1
    [[ "$footnote_count" == "0" ]] || return 1
}
