# shellcheck shell=bash
# ABOUTME: RT-78.39 - review demonstrations publish usable article and reviewed-item SVGs.
# ABOUTME: The column demonstration includes article media and every referenced SVG is well formed.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(review_example_dir)" || return 1

    local column_image
    column_image="$(htmlq -f "$build_dir/book-reviews/the-glass-archive/index.html" -a src '.featured-image-col img')"
    [[ -n "$column_image" ]] || return 1

    local -a pages=(
        "$build_dir/book-reviews/the-glass-archive/index.html"
        "$build_dir/book-reviews/book-banner/index.html"
        "$build_dir/book-reviews/book-featured/index.html"
        "$build_dir/game-reviews/signal-at-dusk/index.html"
        "$build_dir/game-reviews/game-hero/index.html"
        "$build_dir/game-reviews/game-text/index.html"
    )
    local -a image_sources=()
    local page
    for page in "${pages[@]}"; do
        local -a page_sources
        mapfile -t page_sources < <(htmlq -f "$page" -a src 'img')
        image_sources+=("${page_sources[@]}")
    done

    local image_source
    for image_source in "${image_sources[@]}"; do
        [[ "$image_source" == *.svg ]] || continue
        xmlstarlet val --quiet --well-formed "$build_dir/${image_source#/}" || return 1
    done
}
