# shellcheck shell=bash
# ABOUTME: RT-78.15 - reviews without ratings have no rating wrapper.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page generic)" || return 1
    [[ -z "$(htmlq -f "$page" '.review-rating, .review-rating-strip, .review-rating-value')" ]]
}
