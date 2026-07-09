# shellcheck shell=bash
# ABOUTME: RT-72.36 - local exampleSite pages use local theme CSS and JS assets.
# ABOUTME: Prevents make serve from loading stale deployed assets during audio UT.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local page
    page="$(rt72_audiobook_page)" || return 1

    local asset
    while IFS= read -r asset; do
        case "$asset" in
            http://*|https://*)
                printf '    local render emitted absolute stylesheet: %s\n' "$asset" >&2
                return 1
                ;;
        esac
    done < <(htmlq -f "$page" -a href 'link[rel="stylesheet"]')

    while IFS= read -r asset; do
        case "$asset" in
            http://*|https://*)
                printf '    local render emitted absolute script: %s\n' "$asset" >&2
                return 1
                ;;
        esac
    done < <(htmlq -f "$page" -a src 'script')
}
