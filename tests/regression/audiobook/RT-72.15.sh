# shellcheck shell=bash
# ABOUTME: RT-72.15 - per-item completion controls are present.
# ABOUTME: Item rows expose a mark-complete action.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa resume
}
