# shellcheck shell=bash
# ABOUTME: RT-72.30 - item list remains available beside error state.
# ABOUTME: Alternate item selection remains rendered when errors occur.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa error
}
