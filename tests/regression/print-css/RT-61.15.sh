# shellcheck shell=bash
# ABOUTME: RT-61.15 — print.css contains a[href^="http"]::after rule expanding the URL.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE 'a\[href\^=["\047]?http[s]?["\047]?\]::after' "$css"; then
        printf '    no a[href^="http"]::after rule\n' >&2
        return 1
    fi
    if ! grep -qE 'content:[[:space:]]*["\047][[:space:]]*\(["\047][[:space:]]*attr\(href\)' "$css"; then
        printf '    no content rule expanding attr(href)\n' >&2
        return 1
    fi
    return 0
}
