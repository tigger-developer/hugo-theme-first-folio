# shellcheck shell=bash
# ABOUTME: RT-66.8 - unresolved relative audiobook src fails with source context.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure "audiobook-unresolved-relative" "audiobook chapter missing-relative src \"missing/ch99.m4a\" cannot be resolved"
}
