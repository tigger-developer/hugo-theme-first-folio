# shellcheck shell=bash
# ABOUTME: RT-78.12 - ten-point ratings normalize continuously.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page game)" || return 1
    [[ "$(htmlq -f "$page" -t '.review-rating-value')" == "8/10" ]] || return 1
    [[ "$(htmlq -f "$page" -a width '.review-rating-clip rect')" == "80" ]]
}
