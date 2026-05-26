# shellcheck shell=bash
# ABOUTME: RT-61.10 — print.css sets body to Asap 12pt weight 400.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE "font-family:[[:space:]]*['\"]?Asap" "$css"; then
        printf '    no Asap font-family rule in print.css\n' >&2
        return 1
    fi
    if ! grep -qE 'font-size:[[:space:]]*12pt' "$css"; then
        printf '    no font-size: 12pt rule in print.css\n' >&2
        return 1
    fi
    if ! grep -qE 'font-weight:[[:space:]]*400' "$css"; then
        printf '    no font-weight: 400 rule in print.css\n' >&2
        return 1
    fi
    return 0
}
