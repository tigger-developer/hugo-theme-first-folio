# shellcheck shell=bash
# ABOUTME: RT-77.2 - masonry cards without a page override retain the site fallback.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(card_opacity_fixture)" || return 1

    local card_styles
    card_styles="$(htmlq -f "$build_dir/index.html" -a style '.masonry-grid .masonry-bg')"
    grep -qE "fallback-card/fallback\.jpg.*opacity: 0\.65;" <<< "$card_styles"
}
