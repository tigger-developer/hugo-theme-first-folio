# shellcheck shell=bash
# ABOUTME: RT-61.7 — print.css has @media print and (orientation: portrait) constraining images to 70%/30%.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE '@media[[:space:]]+(print[[:space:]]+and[[:space:]]+)?\(orientation:[[:space:]]*portrait\)' "$css"; then
        printf '    no @media print + portrait orientation block\n' >&2
        return 1
    fi
    if ! grep -qE 'max-width:[[:space:]]*70%' "$css"; then
        printf '    no max-width: 70%% in print.css\n' >&2
        return 1
    fi
    if ! grep -qE 'max-height:[[:space:]]*30vh' "$css"; then
        printf '    no max-height: 30vh in print.css\n' >&2
        return 1
    fi
    return 0
}
