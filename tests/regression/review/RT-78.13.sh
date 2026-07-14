# shellcheck shell=bash
# ABOUTME: RT-78.13 - rating scale follows site then hardcoded fallback.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local site_page hardcoded_page
    site_page="$(review_page site-scale)" || return 1
    hardcoded_page="$(review_hardcoded_page)" || return 1
    [[ "$(htmlq -f "$site_page" -t '.review-rating-value')" == "3.5/7" ]] || return 1
    [[ "$(htmlq -f "$hardcoded_page" -t '.review-rating-value')" == "2.5/5" ]]
}
