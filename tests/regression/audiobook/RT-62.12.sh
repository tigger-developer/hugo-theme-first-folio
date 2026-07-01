# shellcheck shell=bash
# ABOUTME: RT-62.12 - missing chapter media URL fails with audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure audiobook-missing-src 'audiobook chapter episode-1 is missing src'
}
