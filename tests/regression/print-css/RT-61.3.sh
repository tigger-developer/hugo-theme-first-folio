# shellcheck shell=bash
# ABOUTME: RT-61.3 — print.css hides every chrome class enumerated in the issue Solution > Hide table.
# User action: prints any page; chrome elements (nav, footer, burger, ambience toggle, lightbox,
# carousel arrows, pagination, contact form widgets) must not appear on paper.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    local missing=()
    # Each chrome selector must appear with display:none (allowing whitespace and !important).
    local selectors=(
        '\.site-nav'
        '\.burger-menu'
        '\.ambience-toggle'
        '\.lightbox'
        '\.pagination'
        '\.section-sidebar'
        'iframe'
        'video'
    )
    for s in "${selectors[@]}"; do
        if ! grep -qE "${s}[^{]*\{[^}]*display:[[:space:]]*none" "$css"; then
            missing+=("$s")
        fi
    done
    if (( ${#missing[@]} > 0 )); then
        printf '    Missing display:none for chrome selectors: %s\n' "${missing[*]}" >&2
        return 1
    fi
    return 0
}
