# shellcheck shell=bash
# ABOUTME: RT-75.4 - item-level displayNumber sets an episodic generated fallback label.

# shellcheck source=tests/regression/audiobook/_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-episodic-display-number")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    grep -qxF 'Episode 101' <<< "$labels"
}
