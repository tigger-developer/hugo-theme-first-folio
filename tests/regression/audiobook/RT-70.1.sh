# shellcheck shell=bash
# ABOUTME: RT-70.1 - audiobook pages render a unified player with one play control.
# ABOUTME: The rendered page keeps chapter names visible as tappable item selectors.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

rendered_line_number() {
    local file="$1"
    local pattern="$2"
    local number=0
    local line

    while IFS= read -r line; do
        number=$((number + 1))
        case "$line" in
            *"$pattern"*)
                printf '%s\n' "$number"
                return 0
                ;;
        esac
    done < "$file"

    return 1
}

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

    [[ "$(htmlq -f "$page" '.audiobook-icon-play[data-audiobook-play-icon]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-icon-previous' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-icon-next' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-icon-replay .audiobook-seek-amount' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '.audiobook-icon-forward .audiobook-seek-amount' | wc -c | tr -d ' ')" -gt 0 ]] || return 1

    local seek_values
    seek_values="$(htmlq -f "$page" -a data-audiobook-seek '[data-audiobook-seek]')"
    [[ "$seek_values" == *$'-30'* ]] || return 1
    [[ "$seek_values" == *$'15'* ]] || return 1

    [[ "$(htmlq -f "$page" '[data-audiobook-previous]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-next]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-active-label]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1
    [[ "$(htmlq -f "$page" '[data-audiobook-active-title]' | wc -c | tr -d ' ')" -gt 0 ]] || return 1

    local selector_count
    selector_count="$(htmlq -f "$page" -a data-chapter-id '.audiobook-track-button[data-chapter-id]' | wc -l | tr -d ' ')"
    [[ "$selector_count" == "7" ]] || return 1

    local player_line
    local body_line
    player_line="$(rendered_line_number "$page" 'class="audiobook-player"')" || return 1
    body_line="$(rendered_line_number "$page" 'class="body audio-body"')" || return 1
    [[ "$player_line" -lt "$body_line" ]] || return 1
}
