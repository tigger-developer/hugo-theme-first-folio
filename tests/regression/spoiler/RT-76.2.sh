# shellcheck shell=bash
# ABOUTME: RT-76.2 - block spoilers preserve Markdown structure in rendered HTML.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--block .spoiler__content > p' | grep -c '<p')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block .spoiler__content strong' | grep -c '<strong')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block .spoiler__content a[href]' | grep -c '<a')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.spoiler--block .spoiler__content li' | grep -c '<li')" -eq 2 ]]
}
