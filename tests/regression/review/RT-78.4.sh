# shellcheck shell=bash
# ABOUTME: RT-78.4 - banner review metadata remains inside the header surface.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local page
    page="$(review_page banner)" || return 1
    [[ "$(htmlq -f "$page" '.post-banner .article-header > h1 + .meta + .review-metadata' | grep -c 'review-metadata')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" '.post-banner + .post-container .body' | grep -c 'Banner review body')" -eq 1 ]]
}
