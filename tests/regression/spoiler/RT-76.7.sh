# shellcheck shell=bash
# ABOUTME: RT-76.7 - spoiler and ordinary details disclosures keep distinct contracts.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" 'details.styled-details:not(.spoiler)' | grep -c '<details')" -ge 1 ]] || return 1
    [[ "$(htmlq -f "$page" 'details.spoiler--block:not(.styled-details)' | grep -c '<details')" -eq 1 ]]
}
