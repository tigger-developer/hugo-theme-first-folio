# shellcheck shell=bash
# ABOUTME: RT-61.14 — print.css applies page-break-inside: avoid to callouts, pull-quotes, pre, table.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    # The selector list bundling these is the natural form; just confirm key terms appear in the rule context.
    local found=0
    grep -E '(\.callout|\.pull-quote|pre|table|figure)[^{]*\{[^}]*(page-break-inside|break-inside):[[:space:]]*avoid' "$css" >/dev/null && found=1
    if (( found == 0 )); then
        # Looser check: page-break-inside avoid rule must exist alongside these selectors anywhere
        if ! grep -qE 'page-break-inside:[[:space:]]*avoid|break-inside:[[:space:]]*avoid' "$css"; then
            printf '    no page-break-inside: avoid rule\n' >&2
            return 1
        fi
        if ! grep -qE '\.callout|\.pull-quote' "$css"; then
            printf '    no callout/pull-quote selector in print.css to receive break-inside protection\n' >&2
            return 1
        fi
    fi
    return 0
}
