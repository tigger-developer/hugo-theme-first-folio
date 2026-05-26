# shellcheck shell=bash
# ABOUTME: RT-61.4 — print.css does NOT hide TOC, signpost, related-articles, post-tags, or section-list nav.
# User action: prints an article with TOC, tags, related links; those must be retained.

# shellcheck source=_helpers.sh
source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    local css; css="$(print_css_path)" || return 1
    local offenders=()
    # Selectors that must NOT be set to display:none anywhere in the file.
    local must_not_hide=('\.toc' '\.signpost' '\.related-articles' '\.post-tags' '\.sidebar-nav')
    for s in "${must_not_hide[@]}"; do
        # Look for direct selector with display:none (not as part of a larger word).
        if grep -qE "(^|,|[[:space:]])${s}([[:space:]]|,|\{)[^{]*\{[^}]*display:[[:space:]]*none" "$css"; then
            offenders+=("$s")
        fi
    done
    if (( ${#offenders[@]} > 0 )); then
        printf '    print.css unexpectedly hides editorial selectors: %s\n' "${offenders[*]}" >&2
        return 1
    fi
    return 0
}
