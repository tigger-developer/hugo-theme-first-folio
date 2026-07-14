# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #78 review regression tests.
# ABOUTME: Builds review fixtures and inspects only Hugo's rendered output.

review_fixture_dir() {
    build_fixture "review-valid"
}

review_page() {
    local slug="$1"
    local build_dir
    build_dir="$(review_fixture_dir)" || return 1
    echo "$build_dir/reviews/$slug/index.html"
}

review_cards_page() {
    local build_dir
    build_dir="$(review_fixture_dir)" || return 1
    echo "$build_dir/cards/index.html"
}

review_hardcoded_page() {
    local build_dir
    build_dir="$(build_fixture "review-hardcoded-scale")" || return 1
    echo "$build_dir/review/index.html"
}

review_default_cards_page() {
    local build_dir
    build_dir="$(build_fixture "review-card-default")" || return 1
    echo "$build_dir/cards/index.html"
}

review_example_dir() {
    build_examplesite
}

expect_review_build_failure() {
    local fixture="$1"
    local expected_message="$2"
    local out
    local err
    out="$(mktemp -d "$REGRESSION_TMP/ff-${fixture}-XXXXXX")"
    err="$(mktemp "$REGRESSION_TMP/ff-${fixture}-stderr-XXXXXX")"

    if hugo --source "$FIXTURES_ROOT/$fixture" --destination "$out" --themesDir "$THEME_ROOT/.." --theme "$(basename "$THEME_ROOT")" > /dev/null 2>"$err"; then
        printf '    expected fixture %s to fail Hugo build\n' "$fixture" >&2
        return 1
    fi
    if ! grep -qF "$expected_message" "$err"; then
        printf '    expected failure containing: %s\n' "$expected_message" >&2
        printf '    actual stderr:\n%s\n' "$(cat "$err")" >&2
        return 1
    fi
}
