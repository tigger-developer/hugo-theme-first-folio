# shellcheck shell=bash
# ABOUTME: RT-75.4 - episodic items without labels render title-only.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-episodic-display-number")" || return 1

    [[ "$(htmlq -f "$page" '[data-chapter-id="episode-special"] .audiobook-track-label' | wc -c | tr -d ' ')" == "0" ]] || return 1
    [[ "$(htmlq -f "$page" -t '[data-chapter-id="episode-special"] .audiobook-track-title' | tr -d '\n')" == "Listener Questions" ]]
}
