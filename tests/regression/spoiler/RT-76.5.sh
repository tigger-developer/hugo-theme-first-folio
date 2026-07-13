# shellcheck shell=bash
# ABOUTME: RT-76.5 - spoiler controls expose labels without leaking protected content.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    htmlq -f "$page" -a aria-label '.spoiler--inline > input' | grep -qF 'Spoiler' || return 1
    htmlq -f "$page" -a aria-label '.spoiler--inline > input' | grep -qF 'Character reveal' || return 1
    [[ "$(htmlq -f "$page" 'details.spoiler--block > summary .spoiler__content' | grep -c 'spoiler__content')" -eq 0 ]] || return 1
    [[ "$(htmlq -f "$page" -t 'details.spoiler--block > summary')" == 'Ending details' ]]
}
