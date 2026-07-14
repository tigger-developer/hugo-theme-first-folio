# shellcheck shell=bash
# ABOUTME: RT-78.22 - built-in item types supply appropriate creator roles.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local book game
    book="$(review_page book)" || return 1
    game="$(review_page game)" || return 1
    [[ "$(htmlq -f "$book" -t '.review-creator-label')" == "Author:" ]] || return 1
    [[ "$(htmlq -f "$game" -t '.review-creator-label')" == "Developer:" ]]
}
