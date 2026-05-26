# shellcheck shell=bash
# ABOUTME: RT-61.9 — print.css applies page-break-inside: avoid to figure/img wrappers.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE 'page-break-inside:[[:space:]]*avoid|break-inside:[[:space:]]*avoid' "$css"; then
        printf '    no page-break-inside: avoid rule\n' >&2
        return 1
    fi
    return 0
}
