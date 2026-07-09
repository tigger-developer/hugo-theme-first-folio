# shellcheck shell=bash
# ABOUTME: RT-72.22 - keyboard item movement has matching item controls.
# ABOUTME: Previous and next item controls remain available.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa keyboard
}
