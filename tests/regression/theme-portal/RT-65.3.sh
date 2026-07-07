# shellcheck shell=bash
# ABOUTME: RT-65.3 - Hugo theme portal preview media meets required names and dimensions.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local screenshot="$THEME_ROOT/images/screenshot.png"
    local thumbnail="$THEME_ROOT/images/tn.png"

    [[ -f "$screenshot" ]] || return 1
    [[ -f "$thumbnail" ]] || return 1

    expect_image_size "$screenshot" 1500 1000
    expect_image_size "$thumbnail" 900 600
}
