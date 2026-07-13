# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #76 spoiler regression tests.
# ABOUTME: Builds the example site and invalid fixtures through Hugo's public boundary.

spoiler_example_page() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    echo "$build_dir/journal/shortcode-showcase/index.html"
}

spoiler_built_css() {
    local css_name="$1"
    local build_dir
    build_dir="$(build_examplesite)" || return 1

    local css_file
    css_file="$(find "$build_dir/css" -name "${css_name}.*.css" -print -quit)"
    if [[ -z "$css_file" ]]; then
        printf '    built %s CSS artefact not found\n' "$css_name" >&2
        return 1
    fi
    echo "$css_file"
}

expect_spoiler_build_failure() {
    local fixture="$1"
    local expected_message="$2"
    local out
    local err
    out="$(mktemp -d "$AGENT_TMP/ff-spoiler-invalid-${fixture}-XXXXXX")"
    err="$(mktemp "$AGENT_TMP/ff-spoiler-invalid-${fixture}-stderr-XXXXXX")"
    local result=1

    if hugo --source "$FIXTURES_ROOT/$fixture" --destination "$out" --themesDir "$THEME_ROOT/.." --theme "$(basename "$THEME_ROOT")" > /dev/null 2>"$err"; then
        printf '    expected fixture %s to fail Hugo build\n' "$fixture" >&2
    elif grep -qF "$expected_message" "$err"; then
        result=0
    else
        printf '    expected failure message containing: %s\n' "$expected_message" >&2
        printf '    actual stderr:\n%s\n' "$(cat "$err")" >&2
    fi

    rm -rf "$out" "$err"
    return "$result"
}
