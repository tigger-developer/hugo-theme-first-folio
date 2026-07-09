# shellcheck shell=bash
# ABOUTME: RT-70.1 - audiobook pages render a unified player with one play control.
# ABOUTME: The rendered page keeps chapter names visible as tappable item selectors.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local player_count
    player_count="$(htmlq -f "$page" -a data-audiobook-id '.audiobook-player' | wc -l | tr -d ' ')"
    [[ "$player_count" == "1" ]] || return 1

    local audio_count
    audio_count="$(htmlq -f "$page" -a data-chapter-id 'audio[data-audiobook-id][data-chapter-id]' | wc -l | tr -d ' ')"
    [[ "$audio_count" == "1" ]] || return 1

    local play_count
    play_count="$(htmlq -f "$page" -a aria-label '[data-audiobook-play-toggle]' | wc -l | tr -d ' ')"
    [[ "$play_count" == "1" ]] || return 1

    local seek_values
    seek_values="$(htmlq -f "$page" -a data-audiobook-seek '[data-audiobook-seek]')"
    grep -qxF -- '-30' <<< "$seek_values" || return 1
    grep -qxF -- '15' <<< "$seek_values" || return 1

    [[ "$(htmlq -f "$page" '[data-audiobook-previous]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-next]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-active-label]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-active-title]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1

    local selector_count
    selector_count="$(htmlq -f "$page" -a data-chapter-id '.audiobook-track-button[data-chapter-id]' | wc -l | tr -d ' ')"
    [[ "$selector_count" == "7" ]] || return 1

    local selector_text
    selector_text="$(htmlq -f "$page" -t '.audiobook-track-button')"
    grep -qF 'Front Matter' <<< "$selector_text" || return 1
    grep -qF 'Demo Chapter 1' <<< "$selector_text" || return 1
    grep -qF 'Demo Chapter 6' <<< "$selector_text" || return 1
}
