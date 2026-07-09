# shellcheck shell=bash
# ABOUTME: RT-70.8 - RSS subscription controls do not appear in the main player.
# ABOUTME: Feed setup is kept out of the primary listening surface.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local player_count
    player_count="$(htmlq -f "$page" -a data-audiobook-id '.audiobook-player' | wc -l | tr -d ' ')"
    [[ "$player_count" == "1" ]] || return 1

    local main_feed_controls
    main_feed_controls="$(htmlq -f "$page" '.audiobook-player [data-feed-copy], .audiobook-player .audiobook-feed-link' | wc -c | tr -d ' ')"
    [[ "$main_feed_controls" == "0" ]] || return 1
}
