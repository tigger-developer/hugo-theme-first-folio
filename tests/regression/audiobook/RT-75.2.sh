# shellcheck shell=bash
# ABOUTME: RT-75.2 - front matter and part markers do not consume startNumber sequence values.

# shellcheck source=tests/regression/audiobook/_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-display-numbering")" || return 1

    local labels
    labels="$(htmlq -f "$page" -t '.audiobook-track-label')"

    [[ "$labels" == $'Front Matter\nPart Two\nChapter 13\nChapter 14\nChapter A\nInterlude\nGenerated Track' ]]
}
