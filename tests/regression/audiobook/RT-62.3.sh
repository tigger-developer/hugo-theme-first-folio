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

    grep -qF 'Front Matter' <<< "$titles" || return 1
    grep -qF 'Demo Chapter 6' <<< "$titles" || return 1
    grep -qF '/audio/audiobook-demo/chapter00.m4a' <<< "$sources" || return 1
    grep -qF '/audio/audiobook-demo/chapter06.m4a' <<< "$sources" || return 1
    grep -qF 'front-matter' <<< "$chapter_ids" || return 1
    grep -qF 'chapter-1' <<< "$chapter_ids" || return 1
    grep -qF 'chapter-6' <<< "$chapter_ids" || return 1
}
