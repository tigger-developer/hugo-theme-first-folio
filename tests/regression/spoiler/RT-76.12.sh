# shellcheck shell=bash
# ABOUTME: RT-76.12 - rendered print CSS preserves deliberate spoiler disclosure state.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css_file
    css_file="$(spoiler_built_css "print")" || return 1

    grep -qF '.spoiler__toggle:not(:checked)' "$css_file" || return 1
    grep -qF '.spoiler--block > .spoiler__toggle:not(:checked)' "$css_file" || return 1
    grep -qF 'visibility: hidden' "$css_file"
}
