# shellcheck shell=bash
# ABOUTME: RT-64.4 - generated media src mismatch fails as stale metadata.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    expect_fixture_build_failure "audiobook-generated-src-mismatch" "audiobook media metadata src mismatch"
}
