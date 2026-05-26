# shellcheck shell=bash
# ABOUTME: RT-61.2 — list page <head> includes a media="print" stylesheet link.
# User action: opens a section list (e.g. /blog/) and inspects <head>.

run_test() {
    local build_dir; build_dir="$(build_examplesite)" || return 1
    local list_index="$build_dir/blog/index.html"
    [[ ! -f "$list_index" ]] && list_index="$(find "$build_dir" -name 'index.html' -path '*/blog/index.html' -type f 2>/dev/null | head -1)"
    if [[ ! -f "$list_index" ]]; then
        printf '    no rendered list page found\n' >&2
        return 1
    fi
    if ! grep -qE '<link[^>]*media="print"[^>]*href="[^"]*/css/print\.|<link[^>]*href="[^"]*/css/print\.[^"]*"[^>]*media="print"|rel=stylesheet[^>]*media=print[^>]*print\.|media=print[^>]*print\.' "$list_index"; then
        printf '    media="print" stylesheet link not found in %s\n' "$list_index" >&2
        return 1
    fi
    return 0
}
