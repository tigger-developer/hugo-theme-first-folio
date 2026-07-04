# shellcheck shell=bash
# ABOUTME: RT-64.7 - unresolved RSS enclosure length fails clearly.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure "audiobook-unresolved-length" "audiobook media metadata could not resolve byteLength"
}
