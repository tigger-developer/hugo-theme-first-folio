# shellcheck shell=bash
# ABOUTME: RT-62.18 - browser-level player test restores playback position.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_player_test 'RT-62.18'
}
