# shellcheck shell=bash
# ABOUTME: RT-70.7 - default subscription output avoids named podcast app links.
# ABOUTME: Private feed pages do not overpromise one-tap app handoff.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local link_text
    link_text="$(htmlq -f "$page" -t 'a')"

    if grep -Eq 'Apple Podcasts|Overcast|Castro|AntennaPod' <<< "$link_text"; then
        printf 'named podcast app link was rendered by default\n' >&2
        return 1
    fi
}
