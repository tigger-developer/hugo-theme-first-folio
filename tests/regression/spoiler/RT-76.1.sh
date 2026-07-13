# shellcheck shell=bash
# ABOUTME: RT-76.1 - inline spoilers remain inside their surrounding rendered paragraph.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    local paragraph
    paragraph="$(htmlq -f "$page" 'p:has(.spoiler--inline)')"
    htmlq '.spoiler--inline' <<< "$paragraph" | grep -q '<' || return 1
    htmlq -t 'p' <<< "$paragraph" | grep -qF 'but the review can discuss motive' || return 1
}
