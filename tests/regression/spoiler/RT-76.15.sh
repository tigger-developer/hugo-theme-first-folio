# shellcheck shell=bash
# ABOUTME: RT-76.15 - configured spoiler opacity preserves inherited text colour.

run_test() {
    local build_dir
    build_dir="$(build_fixture "spoiler-opacity")" || return 1

    local config_css
    config_css="$(htmlq -f "$build_dir/demo/index.html" -t 'style[data-spoiler-config]')"
    grep -qF -- '--spoiler-mask-opacity: 0.52;' <<< "$config_css" || return 1

    local main_css
    main_css="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    if [[ -z "$main_css" ]]; then
        printf '    built main CSS artefact not found\n' >&2
        return 1
    fi

    grep -qF 'color: inherit' "$main_css" || return 1
    grep -qF 'opacity: var(--spoiler-mask-opacity, 0.38)' "$main_css"
}
