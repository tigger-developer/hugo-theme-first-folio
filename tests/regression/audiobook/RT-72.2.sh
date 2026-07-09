# shellcheck shell=bash
# ABOUTME: RT-72.2 - playback speed state is exposed to the player script.
# ABOUTME: Rendered speed controls carry machine-readable rates and active state.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa speed
}
