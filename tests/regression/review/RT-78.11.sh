# shellcheck shell=bash
# ABOUTME: RT-78.11 - decimal ratings retain text and normalized clip width.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page book)" || return 1
    [[ "$(htmlq -f "$page" -t '.review-rating-value')" == "4.9/5" ]] || return 1
    [[ "$(htmlq -f "$page" -a width '.review-rating-clip rect')" == "98" ]]
}
