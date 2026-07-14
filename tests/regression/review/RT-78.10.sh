# shellcheck shell=bash
# ABOUTME: RT-78.10 - artwork alt text falls back to reviewed title.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page alt-fallback)" || return 1
    [[ "$(htmlq -f "$page" -a alt '.review-artwork')" == "Fallback Artwork Subject" ]]
}
