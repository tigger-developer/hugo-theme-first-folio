# shellcheck shell=bash
# ABOUTME: RT-72.5 - minute-based sleep timer controls expose durations.
# ABOUTME: The player has machine-readable minute timer values.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa sleepMinute
}
