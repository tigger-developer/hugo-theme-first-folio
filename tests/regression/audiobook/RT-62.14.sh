# shellcheck shell=bash
# ABOUTME: RT-62.14 - missing chapter MIME type fails with audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure audiobook-missing-mime-type 'audiobook chapter episode-1 is missing mimeType'
}
