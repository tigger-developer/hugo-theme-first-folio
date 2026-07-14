# shellcheck shell=bash
# ABOUTME: RT-76.16 - block spoilers ship native controls plus the re-conceal enhancement.

run_test() {
    local build_dir
    build_dir="$(build_fixture "spoiler-opacity")" || return 1
    local page="$build_dir/index.html"

    [[ "$(htmlq -f "$page" '.spoiler--block > .spoiler__toggle + .spoiler__label .spoiler__control-label' | grep -c 'spoiler__control-label')" -eq 1 ]] || return 1
    [[ "$(htmlq -f "$page" 'script[type="module"][src$="/js/spoiler.js"]' | grep -c '<script')" -eq 1 ]] || return 1
    [[ -s "$build_dir/js/spoiler.js" ]]
}
