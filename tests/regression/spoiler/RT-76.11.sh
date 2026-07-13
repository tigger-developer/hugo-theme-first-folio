# shellcheck shell=bash
# ABOUTME: RT-76.11 - rendered screen CSS carries spoiler states through theme variables.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css_file
    css_file="$(spoiler_built_css "main")" || return 1

    grep -qF '.spoiler--inline' "$css_file" || return 1
    grep -qF '.spoiler__toggle:checked' "$css_file" || return 1
    grep -qF ':focus-visible' "$css_file" || return 1
    grep -qF 'var(--color-secondary)' "$css_file" || return 1
    grep -qF 'details.spoiler--block[open]' "$css_file"
}
