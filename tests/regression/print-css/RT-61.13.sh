# shellcheck shell=bash
# ABOUTME: RT-61.13 — print.css contains page-break-after: avoid on h1, h2, h3.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE 'page-break-after:[[:space:]]*avoid|break-after:[[:space:]]*avoid' "$css"; then
        printf '    no page-break-after: avoid rule for headings\n' >&2
        return 1
    fi
    return 0
}
