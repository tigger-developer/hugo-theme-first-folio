# shellcheck shell=bash
# ABOUTME: RT-62.3 - chapter entries expose title, media URL, and stable chapter ID.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(audiobook_demo_page)" || return 1

    local titles sources chapter_ids
    titles="$(htmlq -f "$page" -t '.audiobook-chapter-title')"
    sources="$(htmlq -f "$page" -a src 'audio[data-chapter-id] source')"
    chapter_ids="$(htmlq -f "$page" -a data-chapter-id 'audio[data-chapter-id]')"

    grep -qF 'Demo Chapter 1' <<< "$titles" || return 1
    grep -qF 'Demo Chapter 2' <<< "$titles" || return 1
    grep -qF 'Demo Chapter 3' <<< "$titles" || return 1
    grep -qF '/audio/audiobook-demo/episode-1.m4a' <<< "$sources" || return 1
    grep -qF 'chapter-1' <<< "$chapter_ids" || return 1
    grep -qF 'chapter-2' <<< "$chapter_ids" || return 1
    grep -qF 'chapter-3' <<< "$chapter_ids" || return 1
}
