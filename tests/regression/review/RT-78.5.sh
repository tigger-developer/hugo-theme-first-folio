# shellcheck shell=bash
# ABOUTME: RT-78.5 - both column directions place review metadata first in the text column.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local left right
    left="$(review_page book)" || return 1
    right="$(review_page columns-right)" || return 1
    [[ -z "$(htmlq -f "$left" '.columns-layout > .article-header .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$left" '.columns-layout > .article-header + .post-featured-columns > .featured-image-col + .featured-text-col > .review-metadata + .body')" ]] || return 1
    [[ -z "$(htmlq -f "$right" '.columns-layout > .article-header .review-metadata')" ]] || return 1
    [[ -n "$(htmlq -f "$right" '.columns-layout > .article-header + .post-featured-columns > .featured-text-col:first-child > .review-metadata + .body')" ]]
}
