# shellcheck shell=bash
# ABOUTME: RT-63.5 - unsupported audiobook type fails with an audiobook-specific message.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure "audiobook-invalid-type" "audiobook metadata type must be serial or episodic"
}
