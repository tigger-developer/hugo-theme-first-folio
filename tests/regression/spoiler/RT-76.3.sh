# shellcheck shell=bash
# ABOUTME: RT-76.3 - positional and named inline spoiler forms share one rendered contract.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--inline > input[type="checkbox"]' | grep -c '<input')" -eq 4 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--inline > label > .spoiler__content' | grep -c 'spoiler__content')" -eq 4 ]]
}
