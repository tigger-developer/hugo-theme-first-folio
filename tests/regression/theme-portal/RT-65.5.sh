# shellcheck shell=bash
# ABOUTME: RT-65.5 - production demo build uses the public theme demo URL.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_theme_demo_live)" || return 1

    local page="$build/index.html"
    [[ -f "$page" ]] || return 1

    htmlq -f "$page" 'title' | grep -q 'demo.theme.tadg.ie' || return 1
    htmlq -f "$page" -a content 'meta[property="og:url"]' | grep -qx 'https://demo.theme.tadg.ie/' || return 1
}
