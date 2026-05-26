# shellcheck shell=bash
# ABOUTME: RT-61.8 — print.css has @media print and (orientation: landscape) inverting to 30%/70%.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE '@media[[:space:]]+(print[[:space:]]+and[[:space:]]+)?\(orientation:[[:space:]]*landscape\)' "$css"; then
        printf '    no @media print + landscape orientation block\n' >&2
        return 1
    fi
    if ! grep -qE 'max-width:[[:space:]]*30%' "$css"; then
        printf '    no max-width: 30%% in print.css\n' >&2
        return 1
    fi
    if ! grep -qE 'max-height:[[:space:]]*70vh' "$css"; then
        printf '    no max-height: 70vh in print.css\n' >&2
        return 1
    fi
    return 0
}
