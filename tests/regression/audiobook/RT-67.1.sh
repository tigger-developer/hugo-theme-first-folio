# shellcheck shell=bash
# ABOUTME: RT-67.1 - audio pages expose default feed subscription controls.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local feed_links
    feed_links="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel .audiobook-feed-link')"
    grep -qxF '/podcast-demo/feed.xml' <<< "$feed_links"

    local feed_text
    feed_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel .audiobook-feed-link' | tr -d '\n')"
    [[ "$feed_text" == "Podcast Feed Link" ]]

    local copy_urls
    copy_urls="$(htmlq -f "$page" -a data-copy-value '.audiobook-subscribe-panel [data-audio-assist-copy]')"
    grep -qxF 'https://example.com/podcast-demo/feed.xml' <<< "$copy_urls"

    local copy_text
    copy_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel .audiobook-copy-button' | tr -d '\n')"
    [[ "$copy_text" == "⧉" ]]

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel summary' | tr -d '\n')"
    [[ "$summary_text" == "Listen in your favourite podcast app" ]]

    local prompt_text
    prompt_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel .audiobook-subscribe-prompt' | tr -d '\n')"
    [[ "$prompt_text" == "Copy this Podcast Feed Link." ]]

    local app_text
    app_text="$(htmlq -f "$page" -t '.audiobook-subscribe-panel a')"
    if grep -Eq 'Apple Podcasts|Overcast|Castro|AntennaPod' <<< "$app_text"; then
        return 1
    fi
}
