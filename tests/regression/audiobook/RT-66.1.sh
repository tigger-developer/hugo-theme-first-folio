# shellcheck shell=bash
# ABOUTME: RT-66.1 - same-bundle audiobook src resolves to page-resource URL in HTML.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_fixture_page "audiobook-relative-resources")" || return 1

    local sources
    sources="$(htmlq -f "$page" -a src 'audio source')"
    grep -qxF '/audiobook-demo/ch00.m4a' <<< "$sources"
}
