# shellcheck shell=bash
# ABOUTME: RT-62.4 - fixture without site-local audiobook template uses theme-owned layout.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page audiobook-no-local-template)" || return 1

    local marker
    marker="$(htmlq -f "$page" -a data-audiobook-theme-layout '.audiobook-page')"
    [[ "$marker" == "first-folio" ]]
}
