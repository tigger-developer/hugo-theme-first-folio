# shellcheck shell=bash
# ABOUTME: RT-70.15 - exampleSite audiobook and podcast demos share one UX structure.
# ABOUTME: Differences are limited to item labels and content semantics.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local audiobook_page
    local podcast_page
    audiobook_page="$(audiobook_demo_page)" || return 1
    podcast_page="$(podcast_demo_page)" || return 1

    for selector in '.audiobook-player' '.audiobook-sidebar' '.audiobook-homescreen-panel[open]' '.audiobook-subscribe-panel[open]'; do
        local audiobook_count
        local podcast_count
        audiobook_count="$(htmlq -f "$audiobook_page" "$selector" | wc -c | tr -d ' ')"
        podcast_count="$(htmlq -f "$podcast_page" "$selector" | wc -c | tr -d ' ')"
        [[ "$audiobook_count" -gt 0 ]] || return 1
        [[ "$podcast_count" -gt 0 ]] || return 1
    done

    local audiobook_label
    local podcast_label
    audiobook_label="$(htmlq -f "$audiobook_page" -t '[data-audiobook-active-label]' | tr -d '\n')"
    podcast_label="$(htmlq -f "$podcast_page" -t '[data-audiobook-active-label]' | tr -d '\n')"

    [[ "$audiobook_label" == "Front Matter" ]] || return 1
    [[ "$podcast_label" == "Episode 1" ]] || return 1
}
