# shellcheck shell=bash
# ABOUTME: RT-78.16 - configured rating strips replace the theme default.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page book)" || return 1
    [[ "$(htmlq -f "$page" -a href '.review-rating-base')" == "/images/review-hearts.svg" ]] || return 1
    [[ "$(htmlq -f "$page" -a href '.review-rating-fill')" == "/images/review-hearts.svg" ]]
}
