# shellcheck shell=bash
# ABOUTME: RT-76.19 - the block spoiler label spans its container with centred text.

run_test() {
    local build_dir
    build_dir="$(build_fixture "spoiler-opacity")" || return 1

    local main_css
    main_css="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    if [[ -z "$main_css" ]]; then
        printf '    built main CSS artefact not found\n' >&2
        return 1
    fi

    local label_rule
    label_rule="$(sed -n '/^\.spoiler--block > \.spoiler__label \.spoiler__control-label {$/,/^}$/p' "$main_css")"
    grep -qF 'inset-inline: 0' <<< "$label_rule" || return 1
    grep -qF 'inline-size: auto' <<< "$label_rule" || return 1
    grep -qF 'text-align: center' <<< "$label_rule"
}
