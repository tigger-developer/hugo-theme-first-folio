# shellcheck shell=bash
# ABOUTME: RT-78.31 - masonry review metadata is disabled by default.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_default_cards_page)" || return 1
    [[ -z "$(htmlq -f "$page" '.masonry-item:not(.carousel-card) .card-review')" ]]
}
