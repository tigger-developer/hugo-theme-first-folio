# shellcheck shell=bash
# ABOUTME: RT-72.3 - player feedback region exists for speed changes.
# ABOUTME: Script-driven control feedback has a rendered target.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa speed
}
