# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #72 audio player regression tests.
# ABOUTME: Keeps rendered HTML assertions consistent across the RT-72 pack.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

rt72_audiobook_page() {
    audiobook_demo_page
}

rt72_podcast_page() {
    podcast_demo_page
}

rt72_label_fixture_page() {
    local build_dir
    build_dir="$(build_fixture audiobook-custom-labels)" || return 1
    echo "$build_dir/audiobook-demo/index.html"
}

rt72_count() {
    local file="$1"
    local selector="$2"
    htmlq -f "$file" "$selector" | wc -c | tr -d ' '
}

rt72_attr_count() {
    local file="$1"
    local attr="$2"
    local selector="$3"
    htmlq -f "$file" -a "$attr" "$selector" | wc -l | tr -d ' '
}
