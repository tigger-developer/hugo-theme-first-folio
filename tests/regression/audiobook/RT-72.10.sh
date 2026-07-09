# shellcheck shell=bash
# ABOUTME: RT-72.10 - part markers can render as non-numbered audio items.
# ABOUTME: Explicit section labels remain separate from numbered items.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_label_fixture_page)" || return 1
    [[ "$(htmlq -f "$page" -t '[data-chapter-id="part-one"] .audiobook-track-label' | tr -d '\n')" == "Part One" ]]
}
