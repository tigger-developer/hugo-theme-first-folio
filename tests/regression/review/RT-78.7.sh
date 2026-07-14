# shellcheck shell=bash
# ABOUTME: RT-78.7 - hero and featured media remain outside review headers.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local hero featured
    hero="$(review_page hero)" || return 1
    featured="$(review_page featured)" || return 1
    [[ "$(htmlq -f "$hero" '.article-header + .post-hero' | grep -c 'post-hero')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$featured" '.article-header + .post-featured' | grep -c 'post-featured')" -eq 1 ]]
}
