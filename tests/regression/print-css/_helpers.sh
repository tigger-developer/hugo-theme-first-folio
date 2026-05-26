# shellcheck shell=bash
# ABOUTME: Shared helpers for print-css RTs. Sourced by each RT in this group.
# ABOUTME: Locates the fingerprinted print.css in the built exampleSite.

print_css_path() {
    local build_dir
    build_dir="$(build_examplesite)" || return 1
    local css
    css="$(find "$build_dir/css" -name 'print.*.css' -type f 2>/dev/null | head -1)"
    if [[ -z "$css" ]]; then
        printf '    print.css artefact not found under %s/css/\n' "$build_dir" >&2
        return 1
    fi
    echo "$css"
}

# Grep wrapper that fails loudly when the expected pattern is missing.
expect_in_print_css() {
    local pattern="$1"
    local label="${2:-pattern}"
    local css; css="$(print_css_path)" || return 1
    if ! grep -qE "$pattern" "$css"; then
        printf '    Expected %s in print.css (pattern: %s)\n' "$label" "$pattern" >&2
        return 1
    fi
    return 0
}

# Grep wrapper that fails when the pattern IS present (used for "must not contain").
expect_not_in_print_css() {
    local pattern="$1"
    local label="${2:-pattern}"
    local css; css="$(print_css_path)" || return 1
    if grep -qE "$pattern" "$css"; then
        printf '    Unexpected %s in print.css (pattern: %s)\n' "$label" "$pattern" >&2
        grep -E "$pattern" "$css" | head -5 | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
