# shellcheck shell=bash
# ABOUTME: RT-61.17 — print.css collapses .columns-layout and .post-featured-columns to single column.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE '\.columns-layout|\.post-featured-columns' "$css"; then
        printf '    no rule targeting .columns-layout or .post-featured-columns\n' >&2
        return 1
    fi
    if ! grep -qE 'grid-template-columns:[[:space:]]*1fr|display:[[:space:]]*block' "$css"; then
        printf '    no single-column collapse rule (grid-template-columns: 1fr OR display: block)\n' >&2
        return 1
    fi
    return 0
}
