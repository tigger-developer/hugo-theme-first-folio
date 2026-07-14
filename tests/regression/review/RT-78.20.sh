# shellcheck shell=bash
# ABOUTME: RT-78.20 - invalid review item-type slugs stop the Hugo build.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_review_build_failure "review-invalid-item-type" "review.itemType"
}
