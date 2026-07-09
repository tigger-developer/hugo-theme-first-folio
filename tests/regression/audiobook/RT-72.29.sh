# shellcheck shell=bash
# ABOUTME: RT-72.29 - item playback errors have a player-level target.
# ABOUTME: Error events can render a clear status message.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa error
}
