# shellcheck shell=bash
# ABOUTME: RT-65.6 - public example build has valid HTML links and audio feeds.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build
    build="$(build_theme_demo_live)" || return 1

    htmltest "$build" -c "$THEME_ROOT/.htmltest.yml" --skip-external --log-level 3 || return 1

    xmlstarlet val --well-formed "$build/podcast-demo/feed.xml" >/dev/null || return 1
    xmlstarlet val --well-formed "$build/audiobook-demo/feed.xml" >/dev/null || return 1
    xmlstarlet sel -t -v '/rss/channel/link' "$build/podcast-demo/feed.xml" | grep -qx 'https://demo.theme.tadg.ie/podcast-demo/' || return 1
    xmlstarlet sel -t -v '/rss/channel/link' "$build/audiobook-demo/feed.xml" | grep -qx 'https://demo.theme.tadg.ie/audiobook-demo/' || return 1
}
