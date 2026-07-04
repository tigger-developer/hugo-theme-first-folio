# shellcheck shell=bash
# ABOUTME: RT-64.10 - audio demos can choose existing visual layouts independently.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_examplesite)" || return 1

    local podcast_page="$build/podcast-demo/index.html"
    local audiobook_page="$build/audiobook-demo/index.html"

    [[ -f "$podcast_page" ]] || return 1
    [[ -f "$audiobook_page" ]] || return 1

    htmlq -f "$podcast_page" '.post-container.dark-bg' | grep -q '<' || return 1
    if htmlq -f "$podcast_page" '#dark-mode-toggle' | grep -q '<'; then
        printf '    background podcast page unexpectedly showed ambience toggle\n' >&2
        return 1
    fi

    htmlq -f "$audiobook_page" '.post-hero img' | grep -q '<' || return 1
    htmlq -f "$audiobook_page" '#dark-mode-toggle' | grep -q '<' || return 1
    if htmlq -f "$audiobook_page" '.post-container.dark-bg' | grep -q '<'; then
        printf '    hero audiobook page unexpectedly rendered as background\n' >&2
        return 1
    fi
}
