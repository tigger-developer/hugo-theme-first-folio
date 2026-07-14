# shellcheck shell=bash
# ABOUTME: RT-76.4 - inline and block spoilers use unchecked native controls.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--inline > input[type="checkbox"]:not([checked])' | grep -c '<input')" -eq 4 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block > input[type="checkbox"]:not([checked])' | grep -c '<input')" -eq 1 ]]
}
