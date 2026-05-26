# shellcheck shell=bash
# ABOUTME: RT-61.2 — list page <head> includes a media="print" stylesheet link.
# User action: opens a section list (e.g. /journal/) and inspects <head>.

run_test() {
    local build_dir; build_dir="$(build_examplesite)" || return 1
    # Try common section names in the exampleSite. journal/ is the canonical list.
    local list_index=""
    for cand in journal stories poetry recipes blog photography; do
        if [[ -f "$build_dir/$cand/index.html" ]]; then
            list_index="$build_dir/$cand/index.html"
            break
        fi
    done
    if [[ -z "$list_index" ]]; then
        printf '    no rendered section-list page found in %s\n' "$build_dir" >&2
        return 1
    fi
    if ! grep -qE '<link[^>]*media="print"[^>]*href="[^"]*/css/print\.|<link[^>]*href="[^"]*/css/print\.[^"]*"[^>]*media="print"' "$list_index"; then
        printf '    media="print" stylesheet link not found in %s\n' "$list_index" >&2
        return 1
    fi
    return 0
}
