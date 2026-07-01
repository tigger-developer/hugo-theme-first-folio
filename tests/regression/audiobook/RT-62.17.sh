# shellcheck shell=bash
# ABOUTME: RT-62.17 - browser-level player test stores playback position.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_player_test 'RT-62.17'
}
