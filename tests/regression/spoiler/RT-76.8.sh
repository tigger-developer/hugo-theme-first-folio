# shellcheck shell=bash
# ABOUTME: RT-76.8 - ambiguous spoiler input fails at the Hugo build boundary.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_spoiler_build_failure "spoiler-invalid-ambiguous" "spoiler shortcode cannot combine text and inner content"
}
