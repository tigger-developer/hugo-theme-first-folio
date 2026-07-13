# shellcheck shell=bash
# ABOUTME: RT-76.6 - every inline spoiler has an independent checkbox and matching label.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    mapfile -t ids < <(htmlq -f "$page" -a id '.spoiler--inline > input')
    mapfile -t labels < <(htmlq -f "$page" -a for '.spoiler--inline > label')
    [[ "${#ids[@]}" -eq 4 ]] || return 1
    [[ "$(printf '%s\n' "${ids[@]}" | sort -u | wc -l | tr -d ' ')" -eq 4 ]] || return 1
    [[ "$(printf '%s\n' "${ids[@]}")" == "$(printf '%s\n' "${labels[@]}")" ]]
}
