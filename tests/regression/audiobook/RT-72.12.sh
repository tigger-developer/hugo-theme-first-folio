# shellcheck shell=bash
# ABOUTME: RT-72.12 - top-level work resume affordance is present.
# ABOUTME: Stored-position resume state has a rendered target.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa resume
}
