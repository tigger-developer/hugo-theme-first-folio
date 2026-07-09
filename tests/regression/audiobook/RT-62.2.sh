# shellcheck shell=bash
# ABOUTME: RT-62.2 - generated audiobook page contains one selector item per configured chapter.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local count
    count="$(htmlq -f "$page" -a data-chapter-id '.audiobook-track-button[data-chapter-id]' | wc -l | tr -d ' ')"
    if [[ "$count" == "7" ]]; then
        return 0
    fi

    printf '    expected 7 audiobook selector items, found %s\n' "$count" >&2
    return 1
}
