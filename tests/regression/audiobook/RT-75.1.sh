# shellcheck shell=bash
# ABOUTME: RT-75.1 - serial startNumber sets the first generated item label.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Chapter 13' <<< "$labels" || return 1
    grep -qxF 'Chapter 14' <<< "$labels"
}
