# shellcheck shell=bash
# ABOUTME: RT-67.2 - audio subscription chooser copy can be configured in front matter.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-subscribe-copy")" || return 1

    local summary_text
    summary_text="$(htmlq -f "$page" -t '.audiobook-subscribe details summary' | tr -d '\n')"
    [[ "$summary_text" == "Listen in an app" ]]

    local prompt_text
    prompt_text="$(htmlq -f "$page" -t '.audiobook-subscribe .audiobook-subscribe-prompt' | tr -d '\n')"
    [[ "$prompt_text" == "Choose where to open this feed." ]]
}
