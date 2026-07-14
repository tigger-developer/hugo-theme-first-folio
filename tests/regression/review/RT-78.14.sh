# shellcheck shell=bash
# ABOUTME: RT-78.14 - zero ratings retain text with an empty foreground clip.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page zero)" || return 1
    [[ "$(htmlq -f "$page" -t '.review-rating-value')" == "0/5" ]] || return 1
    [[ "$(htmlq -f "$page" -a width '.review-rating-clip rect')" == "0" ]]
}
