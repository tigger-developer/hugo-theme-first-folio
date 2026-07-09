# shellcheck shell=bash
# ABOUTME: RT-72.11 - absent labels retain sensible fallback labels.
# ABOUTME: Configured item terminology feeds the fallback label.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_label_fixture_page)" || return 1
    [[ "$(htmlq -f "$page" -a data-chapter-label '[data-chapter-id="stanza-1"][data-audiobook-track]' | tr -d '\n')" == "Stanza 1" ]]
}
