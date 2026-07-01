# shellcheck shell=bash
# ABOUTME: RT-62.19 - browser-level player test ignores invalid or missing stored positions.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    run_player_test 'RT-62.19'
}
