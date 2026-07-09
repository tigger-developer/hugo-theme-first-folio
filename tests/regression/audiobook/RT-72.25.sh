# shellcheck shell=bash
# ABOUTME: RT-72.25 - media-session metadata has rendered source data.
# ABOUTME: Player root exposes work title and author metadata to JavaScript.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/_rt72_jxa.sh"

run_test() {
    rt72_jxa media
}
