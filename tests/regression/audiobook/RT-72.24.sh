# shellcheck shell=bash
# ABOUTME: RT-72.24 - shortcut feedback has a live region.
# ABOUTME: Keyboard actions can announce transient player feedback.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa keyboard
}
