# shellcheck shell=bash
# ABOUTME: RT-76.18 - the compact block label uses the unmodified theme accent.

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
    grep -qF 'border: 2px solid var(--color-secondary)' <<< "$label_rule" || return 1
    grep -qF 'background-color: color-mix(in srgb, var(--color-secondary) 12%, transparent)' <<< "$label_rule" || return 1
    grep -qF 'color: var(--color-secondary)' <<< "$label_rule" || return 1
    grep -qF 'font-weight: 600' <<< "$label_rule" || return 1

    local focus_rule
    focus_rule="$(sed -n '/^\.spoiler--block > \.spoiler__toggle:focus-visible + \.spoiler__label \.spoiler__control-label {$/,/^}$/p' "$main_css")"
    grep -qF 'outline: 0.2rem solid var(--color-secondary)' <<< "$focus_rule"
}
