# shellcheck shell=bash
# ABOUTME: RT-75.5 - explicit item labels are the only user-facing item prefixes.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Interlude' <<< "$labels" || return 1
}
