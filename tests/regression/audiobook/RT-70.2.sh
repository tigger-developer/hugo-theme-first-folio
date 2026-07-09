# shellcheck shell=bash
# ABOUTME: RT-70.2 - podcast pages render the same unified player structure.
# ABOUTME: The rendered page keeps episode names visible as tappable item selectors.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

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

    local active_label
    active_label="$(htmlq -f "$page" -t '[data-audiobook-active-label]' | tr -d '\n')"
    [[ "$active_label" == "Episode 1" ]] || return 1

    local selector_count
    selector_count="$(htmlq -f "$page" -a data-chapter-id '.audiobook-track-button[data-chapter-id]' | wc -l | tr -d ' ')"
    [[ "$selector_count" == "3" ]] || return 1

    local selector_text
    selector_text="$(htmlq -f "$page" -t '.audiobook-track-button')"
    grep -qF 'Demo Episode 1' <<< "$selector_text" || return 1
    grep -qF 'Demo Episode 2' <<< "$selector_text" || return 1
    grep -qF 'Demo Episode 3' <<< "$selector_text" || return 1

    local player_line
    local body_line
    player_line="$(grep -n 'class="audiobook-player"' "$page" | head -n1 | cut -d: -f1)"
    body_line="$(grep -n 'This page demonstrates First Folio' "$page" | head -n1 | cut -d: -f1)"
    [[ "$player_line" -lt "$body_line" ]] || return 1
}
