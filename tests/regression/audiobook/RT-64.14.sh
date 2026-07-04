# shellcheck shell=bash
# ABOUTME: RT-64.14 - homepage carousel includes both podcast and audiobook examples.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_examplesite)" || return 1

    local page="$build/index.html"
    [[ -f "$page" ]] || return 1

    local carousel_links
    carousel_links="$(htmlq -f "$page" -a href '.carousel-container a[href]')"
    grep -qF '/podcast-demo/' <<< "$carousel_links" || return 1
    grep -qF '/audiobook-demo/' <<< "$carousel_links" || return 1
}
