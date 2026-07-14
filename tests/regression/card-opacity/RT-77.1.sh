# shellcheck shell=bash
# ABOUTME: RT-77.1 - article and masonry card opacity overrides remain independent.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(card_opacity_fixture)" || return 1

    local article_style
    article_style="$(htmlq -f "$build_dir/override-card/index.html" -a style '.post-hero img')"
    grep -qF 'opacity: 0.5;' <<< "$article_style" || return 1

    local card_styles
    card_styles="$(htmlq -f "$build_dir/index.html" -a style '.masonry-grid .masonry-bg')"
    grep -qE "override-card/hero\.jpg.*opacity: 0\.8;" <<< "$card_styles"
}
