# shellcheck shell=bash
# ABOUTME: RT-78.5 - both column directions retain full-width review headers.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local left right
    left="$(review_page book)" || return 1
    right="$(review_page columns-right)" || return 1
    [[ "$(htmlq -f "$left" '.columns-layout > .article-header + .post-featured-columns' | grep -c 'post-featured-columns')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$right" '.columns-layout > .article-header + .post-featured-columns' | grep -c 'post-featured-columns')" -eq 1 ]]
}
