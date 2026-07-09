# shellcheck shell=bash
# ABOUTME: RT-72.27 - media-session transport actions map to rendered controls.
# ABOUTME: The player exposes play, seek, previous, and next control targets.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa media
}
