# shellcheck shell=bash
# ABOUTME: RT-62.25 - existing non-audiobook pages keep default single-page rendering.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_examplesite)" || return 1
    local page="$build/journal/typography-guide/index.html"

    [[ -f "$page" ]] || return 1
    if htmlq -f "$page" '.audiobook-page' | grep -q '<'; then
        printf '    non-audiobook page unexpectedly rendered audiobook layout\n' >&2
        return 1
    fi
}
