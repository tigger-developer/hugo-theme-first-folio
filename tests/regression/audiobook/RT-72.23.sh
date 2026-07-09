# shellcheck shell=bash
# ABOUTME: RT-72.23 - keyboard speed changes have ordered speed presets.
# ABOUTME: The player exposes multiple speed values for faster/slower shortcuts.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa keyboard
}
