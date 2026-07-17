# shellcheck shell=bash
# ABOUTME: RT-78.7 - hero review metadata follows media while featured metadata stays in its header.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local hero featured
    hero="$(review_page hero)" || return 1
    featured="$(review_page featured)" || return 1
    [[ -z "$(htmlq -f "$hero" '.article-header .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$hero" '.article-header + .post-hero + .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$featured" '.article-header > .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$featured" '.article-header + .post-featured')" ]]
}
