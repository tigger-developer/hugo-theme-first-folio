# shellcheck shell=bash
# ABOUTME: RT-72.19 - queue reset control is present.
# ABOUTME: Listener-adjusted order can be reset to canonical page order.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa queue
}
