# shellcheck shell=bash
# ABOUTME: RT-72.6 - end-of-item sleep timer control exists.
# ABOUTME: The player can distinguish end-of-item sleep mode from minute timers.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa sleepEnd
}
