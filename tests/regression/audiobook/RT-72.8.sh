# shellcheck shell=bash
# ABOUTME: RT-72.8 - explicit audio item labels are preserved.
# ABOUTME: Rendered player labels do not renumber explicitly labelled items.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_label_fixture_page)" || return 1
    [[ "$(htmlq -f "$page" -t '[data-chapter-id="labelled-track"] .audiobook-track-label' | tr -d '\n')" == "Track 8" ]]
}
