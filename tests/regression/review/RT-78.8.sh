# shellcheck shell=bash
# ABOUTME: RT-78.8 - page-bundle review artwork resolves with configured alt text.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page book)" || return 1
    [[ "$(htmlq -f "$page" -a src '.review-artwork')" == "/reviews/book/cover.svg" ]] || return 1
    [[ "$(htmlq -f "$page" -a alt '.review-artwork')" == "Abstract blue book cover" ]]
}
