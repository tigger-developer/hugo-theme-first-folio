# shellcheck shell=bash
# ABOUTME: RT-76.13 - block spoilers render a content-sized mask rather than an accordion heading.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(spoiler_example_page)" || return 1

    [[ "$(htmlq -f "$page" '.spoiler--block > .spoiler__toggle + .spoiler__label + .spoiler__content' | grep -c 'spoiler__content')" -eq 1 ]] || return 1

    local css_file
    css_file="$(spoiler_built_css "main")" || return 1
    grep -qF '.spoiler--block > .spoiler__toggle:not(:checked) + .spoiler__label' "$css_file" || return 1
    grep -qF 'inset: 0' "$css_file" || return 1
    grep -qF '.spoiler--block > .spoiler__toggle:not(:checked) ~ .spoiler__content' "$css_file"
}
