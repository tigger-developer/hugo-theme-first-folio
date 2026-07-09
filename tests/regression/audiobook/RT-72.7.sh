# shellcheck shell=bash
# ABOUTME: RT-72.7 - sleep timer cancellation and feedback are exposed.
# ABOUTME: The player has rendered cancel and live-feedback targets.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa sleepEnd
}
