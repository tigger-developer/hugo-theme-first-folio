# shellcheck shell=bash
# ABOUTME: RT-78.19 - invalid rating types and ranges stop Hugo builds.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_review_build_failure "review-invalid-value-type" "review.rating.value must be numeric" || return 1
    expect_review_build_failure "review-invalid-scale" "review.rating.scale must be greater than zero" || return 1
    expect_review_build_failure "review-invalid-negative" "review.rating.value must not be negative" || return 1
    expect_review_build_failure "review-invalid-over-scale" "review.rating.value must not exceed review.rating.scale"
}
