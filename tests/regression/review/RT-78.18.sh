# shellcheck shell=bash
# ABOUTME: RT-78.18 - unresolved review artwork stops the Hugo build.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_review_build_failure "review-invalid-artwork" 'review.artwork.src "absent.svg" is not a page resource'
}
