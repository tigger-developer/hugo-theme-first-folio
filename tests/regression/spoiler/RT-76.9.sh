# shellcheck shell=bash
# ABOUTME: RT-76.9 - empty spoiler input fails at the Hugo build boundary.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_spoiler_build_failure "spoiler-invalid-empty" "spoiler shortcode requires text or inner content"
}
