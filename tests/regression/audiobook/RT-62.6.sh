# shellcheck shell=bash
# ABOUTME: RT-62.6 - generated audiobook page uses copied repo-local demo audio URLs.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local sources
    sources="$(htmlq -f "$page" -a data-chapter-src '.audiobook-track-button[data-chapter-id]')"
    grep -qF '/audio/audiobook-demo/chapter00.m4a' <<< "$sources" || return 1
    grep -qF '/audio/audiobook-demo/chapter01.m4a' <<< "$sources" || return 1
    grep -qF '/audio/audiobook-demo/chapter06.m4a' <<< "$sources" || return 1
}
