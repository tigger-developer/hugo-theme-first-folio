# shellcheck shell=bash
# ABOUTME: RT-72.31 - playable item selection can clear error state.
# ABOUTME: Active item metadata and error target coexist in the rendered player.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa error
}
