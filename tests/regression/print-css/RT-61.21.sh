# shellcheck shell=bash
# ABOUTME: RT-61.21 — print.css overrides .stat / .stats font-size to a print-appropriate value.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local flat; flat="$(print_css_flat)" || return 1
    if ! echo "$flat" | grep -qE '\.(stat|stats)[^{]*\{[^}]*font-size:'; then
        printf '    no font-size override for .stat / .stats\n' >&2
        return 1
    fi
    return 0
}
