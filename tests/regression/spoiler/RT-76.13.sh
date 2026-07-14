# shellcheck shell=bash
# ABOUTME: RT-76.13 - block spoilers render a content-shaped mask rather than an accordion heading.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--block > .spoiler__toggle + .spoiler__label + .spoiler__mask + .spoiler__content' | grep -c 'spoiler__content')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block details, .spoiler--block summary' | grep -c '<')" -eq 0 ]]
}
