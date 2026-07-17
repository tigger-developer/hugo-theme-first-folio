# shellcheck shell=bash
# ABOUTME: RT-78.48 - banner review metadata renders below the image surface.
# ABOUTME: The banner retains title and breadcrumb while review metadata precedes article content.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page banner)" || return 1
    [[ -n "$(htmlq -f "$page" '.post-banner .article-header > h1 + .meta')" ]] || return 1
    [[ -z "$(htmlq -f "$page" '.post-banner .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$page" '.banner-layout .banner-content > .review-metadata + .body')" ]]
}
