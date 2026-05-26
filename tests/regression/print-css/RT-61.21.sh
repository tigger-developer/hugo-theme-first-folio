# shellcheck shell=bash
# ABOUTME: RT-61.21 — print.css overrides .stat / .stats font-size to a print-appropriate value (not screen clamp).

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE '\.stat[^{]*\{[^}]*font-size:|\.stats[^{]*\{[^}]*font-size:' "$css"; then
        printf '    no font-size override for .stat / .stats\n' >&2
        return 1
    fi
    return 0
}
