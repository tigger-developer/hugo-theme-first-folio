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

podcast_demo_page() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    echo "$build_dir/podcast-demo/index.html"
}

podcast_demo_feed() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    echo "$build_dir/podcast-demo/feed.xml"
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

start_examplesite_server() {
    local port="${1:-46813}"
    EXAMPLESITE_SERVER_URL="http://127.0.0.1:${port}"
    EXAMPLESITE_SERVER_LOG="$(mktemp -t "ff-audiobook-server-XXXXXX")"
    hugo server --quiet --source "$THEME_ROOT/exampleSite" --bind 127.0.0.1 --port "$port" --baseURL "$EXAMPLESITE_SERVER_URL/" --disableFastRender --renderToMemory --noHTTPCache >"$EXAMPLESITE_SERVER_LOG" 2>&1 &
    EXAMPLESITE_SERVER_PID="$!"

    for _ in {1..50}; do
        if curl --silent --fail --output /dev/null "$EXAMPLESITE_SERVER_URL/"; then
            return 0
        fi
        sleep 0.1
    done

    printf '    exampleSite server did not become ready:\n%s\n' "$(cat "$EXAMPLESITE_SERVER_LOG")" >&2
    stop_examplesite_server
    return 1
}

stop_examplesite_server() {
    if [[ -n "${EXAMPLESITE_SERVER_PID:-}" ]]; then
        if kill "$EXAMPLESITE_SERVER_PID" 2>/dev/null; then
            if wait "$EXAMPLESITE_SERVER_PID" 2>/dev/null; then
                :
            fi
        fi
        EXAMPLESITE_SERVER_PID=""
    fi
    if [[ -n "${EXAMPLESITE_SERVER_LOG:-}" ]]; then
        rm -f "$EXAMPLESITE_SERVER_LOG"
        EXAMPLESITE_SERVER_LOG=""
    fi
}

http_status() {
    local url="$1"
    curl --silent --output /dev/null --write-out '%{http_code}' "$url"
}

http_content_type() {
    local url="$1"
    curl --silent --output /dev/null --write-out '%{content_type}' "$url"
}

http_download_size() {
    local url="$1"
    curl --silent --fail --output /dev/null --write-out '%{size_download}' "$url"
}
