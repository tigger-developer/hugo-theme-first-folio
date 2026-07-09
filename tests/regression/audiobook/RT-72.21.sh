# shellcheck shell=bash
# ABOUTME: RT-72.21 - keyboard seek shortcuts have matching seek controls.
# ABOUTME: The existing seek intervals are present as machine-readable controls.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa keyboard
}
