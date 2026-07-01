# shellcheck shell=bash
# ABOUTME: RT-62.13 - missing enclosure byte length fails with audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure audiobook-missing-byte-length 'audiobook chapter episode-1 is missing byteLength'
}
