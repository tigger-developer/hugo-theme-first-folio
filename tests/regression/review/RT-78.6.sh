# shellcheck shell=bash
# ABOUTME: RT-78.6 - background and text layouts place reviews before body content.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local background text
    background="$(review_page game)" || return 1
    text="$(review_page text)" || return 1
    [[ "$(htmlq -f "$background" '.post-content > .article-header .review-metadata' | grep -c 'review-metadata')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$text" '.post-content > .article-header + .body' | grep -c 'Text review body')" -eq 1 ]]
}
