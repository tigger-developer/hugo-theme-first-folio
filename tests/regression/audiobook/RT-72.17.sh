# shellcheck shell=bash
# ABOUTME: RT-72.17 - up-next state has a live rendered target.
# ABOUTME: The player can update next-item context after active item changes.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa queue
}
