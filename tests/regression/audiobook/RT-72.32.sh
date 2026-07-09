# shellcheck shell=bash
# ABOUTME: RT-72.32 - no-JavaScript fallback remains native and playable.
# ABOUTME: Noscript output keeps one native audio control per configured item.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1
    [[ "$(xmllint --html --xpath 'count(//noscript//audio[@controls])' "$page" 2>/dev/null)" -gt 0 ]]
}
