# shellcheck shell=bash
# ABOUTME: RT-67.1 - audio pages expose default feed and podcast-app subscription controls.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local feed_links
    feed_links="$(htmlq -f "$page" -a href '.audiobook-subscribe .audiobook-feed-link')"
    grep -qxF '/podcast-demo/feed.xml' <<< "$feed_links"

    local feed_text
    feed_text="$(htmlq -f "$page" -t '.audiobook-subscribe .audiobook-feed-link' | tr -d '\n')"
    [[ "$feed_text" == "RSS feed" ]]

    local copy_urls
    copy_urls="$(htmlq -f "$page" -a data-feed-url '.audiobook-subscribe [data-feed-copy]')"
    grep -qxF 'https://example.com/podcast-demo/feed.xml' <<< "$copy_urls"

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-subscribe details summary' | tr -d '\n')"
    [[ "$summary_text" == "Open in your podcast app" ]]

    local prompt_text
    prompt_text="$(htmlq -f "$page" -t '.audiobook-subscribe .audiobook-subscribe-prompt' | tr -d '\n')"
    [[ "$prompt_text" == "Select your podcast app to listen in." ]]

    local app_text
    app_text="$(htmlq -f "$page" -t '.audiobook-subscribe .audiobook-app-link')"
    grep -qxF 'Apple Podcasts' <<< "$app_text"
    grep -qxF 'Overcast' <<< "$app_text"
    grep -qxF 'Castro' <<< "$app_text"
    grep -qxF 'AntennaPod' <<< "$app_text"

    local app_hrefs
    app_hrefs="$(htmlq -f "$page" -a href '.audiobook-subscribe .audiobook-app-link')"
    grep -qxF 'podcast:https://example.com/podcast-demo/feed.xml' <<< "$app_hrefs"
    grep -qxF 'overcast://x-callback-url/add?url=https%3A%2F%2Fexample.com%2Fpodcast-demo%2Ffeed.xml' <<< "$app_hrefs"
    grep -qxF 'castros://subscribe/https%3A%2F%2Fexample.com%2Fpodcast-demo%2Ffeed.xml' <<< "$app_hrefs"
    grep -qxF 'antennapod-subscribe:https://example.com/podcast-demo/feed.xml' <<< "$app_hrefs"
}
