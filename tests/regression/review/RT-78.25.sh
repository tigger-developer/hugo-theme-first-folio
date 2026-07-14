# shellcheck shell=bash
# ABOUTME: RT-78.25 - downstream partials receive normalized review data.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page film)" || return 1
    [[ "$(htmlq -f "$page" -a data-title '.downstream-review-partial')" == "Film Subject" ]] || return 1
    [[ "$(htmlq -f "$page" -a data-fraction '.downstream-review-partial')" == "0.8" ]]
}
