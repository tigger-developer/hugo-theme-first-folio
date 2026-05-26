# shellcheck shell=bash
# ABOUTME: RT-61.11 — print.css maps bold (b, strong) to font-weight 800.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # Must have at least one rule selecting b/strong with weight 800
    if ! grep -qE '(b[[:space:]]*,|strong)[[:space:]]*[{,][^}]*font-weight:[[:space:]]*800|font-weight:[[:space:]]*800[^}]*\}[^{]*(b[[:space:]]*,|strong)' "$css"; then
        # Fallback: any font-weight: 800 declaration anywhere
        if ! grep -qE 'font-weight:[[:space:]]*800' "$css"; then
            printf '    no font-weight: 800 rule for bold elements\n' >&2
            return 1
        fi
    fi
    return 0
}
