# shellcheck shell=bash
# ABOUTME: RT-72.20 - keyboard shortcut feedback has a rendered target.
# ABOUTME: Play/pause shortcuts share the player feedback region.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa keyboard
}
