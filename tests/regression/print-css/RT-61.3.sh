# shellcheck shell=bash
# ABOUTME: RT-61.3 — print.css hides every chrome class enumerated in the issue Solution > Hide table.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local flat; flat="$(print_css_flat)" || return 1
    local missing=()
    local selectors=(
        '\.site-nav'
        '\.burger-menu'
        '\.ambience-toggle'
        '\.lightbox'
        '\.pagination'
        '\.section-sidebar'
        '\biframe\b'
        '\bvideo\b'
    )
    # Strategy: each selector must appear inside a rule that ends in display: none.
    # We split into rule blocks and check each contains both the selector and display:none.
    for s in "${selectors[@]}"; do
        # Pattern: selector ... { ... display: none ... }
        if ! echo "$flat" | grep -qE "${s}[^{]*\{[^}]*display:[[:space:]]*none"; then
            missing+=("$s")
        fi
    done
    if (( ${#missing[@]} > 0 )); then
        printf '    Missing display:none for chrome selectors: %s\n' "${missing[*]}" >&2
        return 1
    fi
    return 0
}
