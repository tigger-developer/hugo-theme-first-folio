# shellcheck shell=bash
# ABOUTME: RT-72.37 - player-managed hidden controls remain visually hidden.
# ABOUTME: Prevents disclosure menu display styles from overriding the hidden attribute.

source "$(dirname "${BASH_SOURCE[0]}")/_rt72_helpers.sh"

run_test() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1

    local css_file
    css_file="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    [[ -n "$css_file" ]] || return 1

    awk '
        /\.audiobook-player \[hidden\]/ { in_rule = 1 }
        in_rule && /display:[[:space:]]*none/ { found = 1 }
        in_rule && /\}/ { in_rule = 0 }
        END { exit found ? 0 : 1 }
    ' "$css_file"
}
