# shellcheck shell=bash
# ABOUTME: RT-76.7 - block spoilers do not reuse the ordinary details contract.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" 'details.styled-details:not(.spoiler)' | grep -c '<details')" -ge 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block details, .spoiler--block summary' | grep -c '<')" -eq 0 ]] || return 1
    [[ "$(htmlq -f "$page" 'div.spoiler--block > .spoiler__content' | grep -c 'spoiler__content')" -eq 1 ]]
}
