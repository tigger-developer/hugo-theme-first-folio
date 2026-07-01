# shellcheck shell=bash
# ABOUTME: RT-62.6 - generated audiobook page uses copied repo-local demo audio URLs.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local sources
    sources="$(htmlq -f "$page" -a src 'audio source')"
    grep -qF '/audio/audiobook-demo/episode-1.m4a' <<< "$sources" || return 1
    grep -qF '/audio/audiobook-demo/episode-2.m4a' <<< "$sources" || return 1
    grep -qF '/audio/audiobook-demo/episode-3.m4a' <<< "$sources" || return 1
}
