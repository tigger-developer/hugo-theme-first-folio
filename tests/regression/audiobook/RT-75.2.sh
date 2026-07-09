# shellcheck shell=bash
# ABOUTME: RT-75.2 - unlabelled ordinary items render title-only without invented numbers.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-custom-labels")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"
    if grep -qxF 'Stanza unlabelled-track' <<< "$labels"; then
        printf '    unlabelled item rendered an invented fallback label\n' >&2
        return 1
    fi

    [[ "$(htmlq -f "$page" '[data-chapter-id="unlabelled-track"] .audiobook-track-label' | wc -c | tr -d ' ')" == "0" ]] || return 1
    [[ "$(htmlq -f "$page" -t '[data-chapter-id="unlabelled-track"] .audiobook-track-title' | tr -d '\n')" == "Title Only Track" ]]
}
