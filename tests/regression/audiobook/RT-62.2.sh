# shellcheck shell=bash
# ABOUTME: RT-62.2 - generated audiobook page contains one audio control per configured chapter.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local count
    count="$(htmlq -f "$page" 'audio[data-chapter-id]' | grep -c '<audio')"
    if [[ "$count" == "7" ]]; then
        return 0
    fi

    printf '    expected 7 audiobook audio controls, found %s\n' "$count" >&2
    return 1
}
