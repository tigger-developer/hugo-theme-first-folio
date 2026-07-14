# shellcheck shell=bash
# ABOUTME: RT-78.23 - downstream item-type partials are selected dynamically.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page film)" || return 1
    [[ "$(htmlq -f "$page" '.downstream-review-partial' | grep -c 'downstream-review-partial')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" -t '.review-creator-label')" == "Director:" ]]
}
