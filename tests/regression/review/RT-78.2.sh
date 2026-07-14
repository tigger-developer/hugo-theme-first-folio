# shellcheck shell=bash
# ABOUTME: RT-78.2 - hidden article authors do not hide reviewed creators.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page hidden-author)" || return 1
    [[ -z "$(htmlq -f "$page" '.breadcrumb-meta-bright')" ]] || return 1
    [[ "$(htmlq -f "$page" -t '.review-title')" == "Visible Subject" ]] || return 1
    htmlq -f "$page" -t '.review-creator' | grep -qF 'Visible Creator'
}
