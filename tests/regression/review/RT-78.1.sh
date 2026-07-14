# shellcheck shell=bash
# ABOUTME: RT-78.1 - article and reviewed-item creators remain separate.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page book)" || return 1
    [[ "$(htmlq -f "$page" -t '.breadcrumb-meta-bright')" == "Nessa Byrne" ]] || return 1
    htmlq -f "$page" -t '.review-creator' | grep -qF 'Everina Maxwell'
}
