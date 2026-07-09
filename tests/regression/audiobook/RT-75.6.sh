# shellcheck shell=bash
# ABOUTME: RT-75.6 - generated media labels have precedence over displayNumber.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Generated Track' <<< "$labels" || return 1
    if grep -qxF 'Chapter 100' <<< "$labels"; then
        printf '    displayNumber overrode generated label\n' >&2
        return 1
    fi
}
