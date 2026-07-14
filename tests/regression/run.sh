#!/usr/bin/env bash
# ABOUTME: Regression test driver. Iterates over tests/regression/<group>/RT-*.sh and sources each.
# ABOUTME: Each test script must define a `run_test` function returning 0 (pass) or non-zero (fail).
set -euo pipefail
IFS=$'\n\t'

THEME_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TESTS_ROOT="$THEME_ROOT/tests/regression"
FIXTURES_ROOT="$THEME_ROOT/tests/fixtures"
REGRESSION_TMP="$(mktemp -d -t first-folio-regression.XXXXXX)"
# Compatibility alias for existing helpers; all mutable state now lives in the
# operating-system temporary tree owned by this test run.
AGENT_TMP="$REGRESSION_TMP"

export THEME_ROOT TESTS_ROOT FIXTURES_ROOT AGENT_TMP REGRESSION_TMP

PASSED=0
FAILED=0
FAILURES=()

# Build a fixture site once per run; subsequent tests in the same group share the build.
# Each group can opt in by calling `build_fixture <fixture-name>` from inside its setup.
declare -A BUILT_FIXTURES

# shellcheck disable=SC2329  # invoked from per-test scripts that source this driver indirectly
build_fixture() {
    local name="$1"
    if [[ -n "${BUILT_FIXTURES[$name]:-}" ]]; then
        echo "${BUILT_FIXTURES[$name]}"
        return 0
    fi
    local src="$FIXTURES_ROOT/$name"
    if [[ ! -d "$src" ]]; then
        printf 'build_fixture: fixture directory not found: %s\n' "$src" >&2
        return 1
    fi
    local out
    out="$REGRESSION_TMP/fixture-${name}"
    if [[ -d "$out" ]]; then
        echo "$out"
        return 0
    fi
    if hugo --quiet --source "$src" --destination "$out" --themesDir "$THEME_ROOT/.." --theme "$(basename "$THEME_ROOT")" 2>/dev/null; then
        BUILT_FIXTURES[$name]="$out"
        echo "$out"
        return 0
    else
        printf 'build_fixture: hugo build failed for %s\n' "$name" >&2
        return 1
    fi
}

# Build the exampleSite once per run; share the build path across tests.
# Tests query the rendered HTML in this directory with htmlq (tier 2 per WEB.md).
# The exampleSite is the canonical fixture per #54's solution: example content
# in exampleSite/ doubles as the test target.
EXAMPLESITE_BUILD=""
# shellcheck disable=SC2329  # invoked from per-test scripts that source this driver indirectly
build_examplesite() {
    local out="$REGRESSION_TMP/examplesite"
    if [[ -f "$out/index.html" ]]; then
        echo "$out"
        return 0
    fi
    EXAMPLESITE_BUILD="$out"
    if hugo --quiet --source "$THEME_ROOT/exampleSite" --destination "$EXAMPLESITE_BUILD" 2>/dev/null; then
        echo "$EXAMPLESITE_BUILD"
        return 0
    else
        printf 'build_examplesite: hugo build failed\n' >&2
        EXAMPLESITE_BUILD=""
        return 1
    fi
}

# shellcheck disable=SC2329  # invoked via the EXIT trap
cleanup_fixtures() {
    # mktemp-created temp dirs are the documented exception in CODING.md
    # where direct removal (not via `trash`) is acceptable.
    if [[ -d "$REGRESSION_TMP" ]]; then
        rm -rf "$REGRESSION_TMP"
    fi
}
trap cleanup_fixtures EXIT

run_test_file() {
    local file="$1"
    local id
    id="$(basename "$file" .sh)"
    # shellcheck source=/dev/null
    (
        # Subshell isolates each test, so `run_test` from a previous file
        # cannot leak into the next one. No need to `unset -f` here.
        source "$file"
        if declare -F run_test >/dev/null; then
            if run_test; then
                printf '  \033[32mPASS\033[0m %s\n' "$id"
                exit 0
            else
                printf '  \033[31mFAIL\033[0m %s\n' "$id"
                exit 1
            fi
        else
            printf '  \033[33mSKIP\033[0m %s (no run_test function)\n' "$id"
            exit 2
        fi
    )
}

shopt -s nullglob
for group_dir in "$TESTS_ROOT"/*/; do
    group="$(basename "$group_dir")"
    printf '\n\033[1m%s\033[0m\n' "$group"
    for test_file in "$group_dir"/RT-*.sh; do
        if run_test_file "$test_file"; then
            PASSED=$((PASSED + 1))
        else
            rc=$?
            if [[ $rc -eq 1 ]]; then
                FAILED=$((FAILED + 1))
                FAILURES+=("$(basename "$test_file" .sh) in $group")
            fi
        fi
    done
done

printf '\n────────────────────────────────────────\n'
printf 'Passed: \033[32m%d\033[0m   Failed: \033[31m%d\033[0m\n' "$PASSED" "$FAILED"

if [[ ${#FAILURES[@]} -gt 0 ]]; then
    printf '\nFailed tests:\n'
    for f in "${FAILURES[@]}"; do
        printf '  - %s\n' "$f"
    done
    exit 1
fi
exit 0
