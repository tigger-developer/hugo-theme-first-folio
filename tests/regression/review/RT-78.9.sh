# shellcheck shell=bash
# ABOUTME: RT-78.9 - reviews without artwork have no empty artwork element.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page game)" || return 1
    [[ -z "$(htmlq -f "$page" '.review-artwork')" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.review-title')" == "Signal at Dusk" ]]
}
