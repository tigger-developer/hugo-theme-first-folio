# shellcheck shell=bash
# ABOUTME: Shared helpers for issue #62 audiobook regression tests.
# ABOUTME: Builds example/fixture sites and queries generated HTML/XML artefacts.

audiobook_demo_page() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    echo "$build_dir/audiobook-demo/index.html"
}

audiobook_demo_feed() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    echo "$build_dir/audiobook-demo/feed.xml"
}

audiobook_fixture_page() {
    local fixture="$1"
    local build_dir
    build_dir="$(build_fixture "$fixture")" || return 1
    echo "$build_dir/audiobook-demo/index.html"
}

audiobook_fixture_feed() {
    local fixture="$1"
    local build_dir
    build_dir="$(build_fixture "$fixture")" || return 1
    echo "$build_dir/audiobook-demo/feed.xml"
}

expect_fixture_build_failure() {
    local fixture="$1"
    local expected_message="$2"
    local out
    local err
    out="$(mktemp -d -t "ff-audiobook-invalid-${fixture}-XXXXXX")"
    err="$(mktemp -t "ff-audiobook-invalid-${fixture}-stderr-XXXXXX")"
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

feed_item_count() {
    local feed="$1"
    xmlstarlet sel -t -v 'count(/rss/channel/item)' "$feed"
}

run_player_test() {
    local title="$1"
    local browser_path="$THEME_ROOT/.agent/tmp/ms-playwright"
    PLAYWRIGHT_BROWSERS_PATH="$browser_path" npm exec -- playwright test tests/regression/audiobook/player.spec.mjs --grep "$title" --reporter=line --output "$THEME_ROOT/.agent/tmp/playwright-results"
}
