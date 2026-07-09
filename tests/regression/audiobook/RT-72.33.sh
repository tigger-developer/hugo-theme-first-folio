# shellcheck shell=bash
# ABOUTME: RT-72.33 - example audio pages expose the enhanced player regions.
# ABOUTME: Audiobook and podcast demos share speed, sleep, resume, and up-next controls.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local audiobook_page
    local podcast_page
    audiobook_page="$(rt72_audiobook_page)" || return 1
    podcast_page="$(rt72_podcast_page)" || return 1
    for selector in '[data-audiobook-speed-controls]' '[data-audiobook-sleep-controls]' '[data-audiobook-resume-work]' '[data-audiobook-up-next]' '[data-audiobook-error]'; do
        [[ "$(rt72_count "$audiobook_page" "$selector")" -gt 0 ]] || return 1
        [[ "$(rt72_count "$podcast_page" "$selector")" -gt 0 ]] || return 1
    done
}
