# shellcheck shell=bash
# ABOUTME: RT-72.26 - active item metadata is available for media-session updates.
# ABOUTME: Each item exposes label and title data attributes.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa media
}
