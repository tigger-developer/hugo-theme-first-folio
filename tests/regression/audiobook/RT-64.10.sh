# shellcheck shell=bash
# ABOUTME: RT-64.10 - audio layout with background image follows dark-canvas convention.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_examplesite)" || return 1

    local podcast_page="$build/podcast-demo/index.html"
    local audiobook_page="$build/audiobook-demo/index.html"

    [[ -f "$podcast_page" ]] || return 1
    [[ -f "$audiobook_page" ]] || return 1

    htmlq -f "$podcast_page" '.post-container.audio-layout.dark-bg' | grep -q '<' || return 1
    if htmlq -f "$podcast_page" '#dark-mode-toggle' | grep -q '<'; then
        printf '    audio podcast page with background unexpectedly showed ambience toggle\n' >&2
        return 1
    fi

    htmlq -f "$audiobook_page" '.post-container.audio-layout.dark-bg' | grep -q '<' || return 1
    if htmlq -f "$audiobook_page" '#dark-mode-toggle' | grep -q '<'; then
        printf '    audio audiobook page with background unexpectedly showed ambience toggle\n' >&2
        return 1
    fi
}
