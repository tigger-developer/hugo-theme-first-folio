# shellcheck shell=bash
# ABOUTME: RT-75.5 - explicit item labels have precedence over displayNumber.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Interlude' <<< "$labels" || return 1
    if grep -qxF 'Chapter 99' <<< "$labels"; then
        printf '    displayNumber overrode explicit label\n' >&2
        return 1
    fi
}
