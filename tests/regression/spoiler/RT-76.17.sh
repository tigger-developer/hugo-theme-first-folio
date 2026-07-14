# shellcheck shell=bash
# ABOUTME: RT-76.17 - the entire concealed block mask remains a native reveal target.

run_test() {
    local build_dir
    build_dir="$(build_fixture "spoiler-opacity")" || return 1

    local main_css
    main_css="$(find "$build_dir/css" -name 'main.*.css' -print -quit)"
    if [[ -z "$main_css" ]]; then
        printf '    built main CSS artefact not found\n' >&2
        return 1
    fi

    local concealed_label_rule
    concealed_label_rule="$(sed -n '/^\.spoiler--block > \.spoiler__toggle:not(:checked) + \.spoiler__label {$/,/^}$/p' "$main_css")"
    grep -qF '.spoiler--block > .spoiler__toggle:not(:checked) + .spoiler__label' <<< "$concealed_label_rule" || return 1
    grep -qF 'block-size: auto' <<< "$concealed_label_rule"
}
