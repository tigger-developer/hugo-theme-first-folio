# shellcheck shell=bash
# ABOUTME: RT-72.13 - per-item resume affordances are present.
# ABOUTME: Item rows expose subtle resume status targets.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa resume
}
