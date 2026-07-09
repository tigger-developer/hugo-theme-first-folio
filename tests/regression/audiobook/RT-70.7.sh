# shellcheck shell=bash
# ABOUTME: RT-70.7 - default subscription output avoids named podcast app links.
# ABOUTME: Private feed pages do not overpromise one-tap app handoff.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(podcast_demo_page)" || return 1

    local subscribe_link_count
    subscribe_link_count="$(htmlq -f "$page" -a href '.audiobook-subscribe-panel a' | wc -l | tr -d ' ')"

    [[ "$subscribe_link_count" == "1" ]]
}
