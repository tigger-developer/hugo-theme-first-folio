# shellcheck shell=bash
# ABOUTME: RT-61.5 — print.css forces body text to black and background to white,
# ABOUTME: overriding dark-mode custom properties.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # Must force a black body color and white background somewhere
    if ! grep -qE 'color:[[:space:]]*(#000|black|rgb\(0,?[[:space:]]*0,?[[:space:]]*0\))' "$css"; then
        printf '    no rule forcing black body text\n' >&2
        return 1
    fi
    if ! grep -qE 'background(-color)?:[[:space:]]*(#fff|#ffffff|white|rgb\(255,?[[:space:]]*255,?[[:space:]]*255\))' "$css"; then
        printf '    no rule forcing white background\n' >&2
        return 1
    fi
    # Override at least one dark-mode custom property
    if ! grep -qE -- '--bg-(primary|secondary|color):|--text-(color|primary)' "$css"; then
        printf '    no override of dark-mode custom properties (--bg-* / --text-*)\n' >&2
        return 1
    fi
    return 0
}
