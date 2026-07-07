# shellcheck shell=bash
# ABOUTME: RT-65.2 - root Hugo module metadata declares compatible Hugo version.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    [[ "$(root_hugo_value '.module.hugoVersion.extended')" == "true" ]] || return 1
    [[ "$(root_hugo_value '.module.hugoVersion.min')" == "0.155.0" ]] || return 1

    local config
    config="$(hugo config --source "$THEME_ROOT")" || return 1
    grep -q "min = '0.155.0'" <<< "$config" || return 1
    grep -q "extended = true" <<< "$config" || return 1
}
