# shellcheck shell=bash
# ABOUTME: RT-75.3 - appendix-style labels are author-supplied display strings.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Chapter A' <<< "$labels"
}
