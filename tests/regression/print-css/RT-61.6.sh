# shellcheck shell=bash
# ABOUTME: RT-61.6 — print.css suppresses decorative backgrounds, washes, shadows, and gradients.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # Must contain a background-image: none somewhere
    if ! grep -qE 'background-image:[[:space:]]*none' "$css"; then
        printf '    no background-image: none rule\n' >&2
        return 1
    fi
    # Must neutralize box-shadow and backdrop-filter
    if ! grep -qE 'box-shadow:[[:space:]]*none' "$css"; then
        printf '    no box-shadow: none rule\n' >&2
        return 1
    fi
    if ! grep -qE 'backdrop-filter:[[:space:]]*none' "$css"; then
        printf '    no backdrop-filter: none rule\n' >&2
        return 1
    fi
    return 0
}
