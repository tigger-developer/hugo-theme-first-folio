# shellcheck shell=bash
# ABOUTME: RT-78.3 - ordinary articles contain no review artefacts.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page plain)" || return 1
    [[ -z "$(htmlq -f "$page" '.review-metadata, .review-rating')" ]]
}
