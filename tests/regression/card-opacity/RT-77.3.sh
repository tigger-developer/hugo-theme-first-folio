# shellcheck shell=bash
# ABOUTME: RT-77.3 - carousel and narrow masonry opacity values remain independent.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(card_opacity_fixture)" || return 1

    local carousel_style
    carousel_style="$(htmlq -f "$build_dir/index.html" -a style '.carousel-card')"
    grep -qF -- '--carousel-bg-opacity: 0.9; --masonry-bg-opacity: 0.75;' <<< "$carousel_style"
}
