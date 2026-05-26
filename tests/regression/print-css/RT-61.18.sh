# shellcheck shell=bash
# ABOUTME: RT-61.18 — print.css forces <details> content to be visible regardless of [open] state.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local flat; flat="$(print_css_flat)" || return 1
    if ! echo "$flat" | grep -qE 'details[[:space:]]*>[[:space:]]*\*[^{]*\{[^}]*display:[[:space:]]*block'; then
        printf '    no "details > * { display: block }" rule\n' >&2
        return 1
    fi
    return 0
}
