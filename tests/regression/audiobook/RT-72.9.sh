# shellcheck shell=bash
# ABOUTME: RT-72.9 - audio item terminology is configurable.
# ABOUTME: Serial fallback labels can use terms other than Chapter.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_label_fixture_page)" || return 1
    [[ "$(htmlq -f "$page" -t '[data-chapter-id="stanza-1"] .audiobook-track-label' | tr -d '\n')" == "Stanza 1" ]]
}
