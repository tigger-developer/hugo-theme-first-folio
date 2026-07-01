# shellcheck shell=bash
# ABOUTME: RT-62.15 - missing podcast title or description fails with audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure audiobook-missing-title-description 'audiobook metadata requires title and description'
}
