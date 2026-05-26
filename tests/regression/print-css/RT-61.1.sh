# shellcheck shell=bash
# ABOUTME: RT-61.1 — single-post page <head> includes a media="print" stylesheet link.
# User action: opens any article in a browser, inspects <head>. They should see a
# print stylesheet declared with media="print" so the browser knows to use it only when printing.

run_test() {
    local build_dir; build_dir="$(build_examplesite)" || return 1
    local single
    single="$(find "$build_dir" -name 'index.html' -path '*/blog/*' -type f 2>/dev/null | head -1)"
    [[ -z "$single" ]] && single="$(find "$build_dir" -name 'index.html' -type f 2>/dev/null | head -2 | tail -1)"
    if [[ -z "$single" ]]; then
        printf '    no rendered single-post page found\n' >&2
        return 1
    fi
    if ! grep -qE 'rel=stylesheet[^>]*media=print[^>]*href=[^>]*print\.|media=print[^>]*rel=stylesheet[^>]*href=[^>]*print\.|<link[^>]*href="[^"]*/css/print\.[^"]*"[^>]*media="print"|<link[^>]*media="print"[^>]*href="[^"]*/css/print\.' "$single"; then
        printf '    media="print" stylesheet link not found in %s\n' "$single" >&2
        return 1
    fi
    return 0
}
