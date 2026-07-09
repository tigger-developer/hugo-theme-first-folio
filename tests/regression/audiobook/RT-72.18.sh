# shellcheck shell=bash
# ABOUTME: RT-72.18 - queue reordering controls are present.
# ABOUTME: Item rows expose local order movement controls.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa queue
}
