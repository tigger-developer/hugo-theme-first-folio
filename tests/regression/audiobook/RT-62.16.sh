# shellcheck shell=bash
# ABOUTME: RT-62.16 - missing or duplicate chapter IDs fail with audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure audiobook-duplicate-chapter-id 'audiobook chapter id episode-1 is duplicated'
}
