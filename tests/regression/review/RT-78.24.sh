# shellcheck shell=bash
# ABOUTME: RT-78.24 - omitted and unknown item types use the generic renderer.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local generic unknown
    generic="$(review_page generic)" || return 1
    unknown="$(review_page unknown)" || return 1
    [[ -z "$(htmlq -f "$generic" '.review-creator-label')" ]] || return 1
    [[ -z "$(htmlq -f "$unknown" '.review-creator-label')" ]] || return 1
    [[ "$(htmlq -f "$unknown" -t '.review-title')" == "Unknown Type Subject" ]]
}
