# shellcheck shell=bash
# ABOUTME: RT-65.1 - portal metadata exposes current public theme listing fields.

source "$(dirname "${BASH_SOURCE[0]}")/_helpers.sh"

run_test() {
    [[ "$(theme_toml_value '.name')" == "First Folio" ]] || return 1
    [[ "$(theme_toml_value '.license')" == "Apache-2.0" ]] || return 1
    [[ "$(theme_toml_value '.licenselink')" == "https://github.com/tadg-paul/hugo-theme-first-folio/blob/main/LICENSE" ]] || return 1
    [[ "$(theme_toml_value '.homepage')" == "https://github.com/tadg-paul/hugo-theme-first-folio" ]] || return 1
    [[ "$(theme_toml_value '.demosite')" == "https://demo.theme.tadg.ie/" ]] || return 1
    [[ "$(theme_toml_value '.author.name')" == "Taḋg Paul" ]] || return 1
    [[ "$(theme_toml_value '.author.homepage')" == "https://tadg.ie" ]] || return 1
    [[ "$(theme_toml_value '.min_version')" == "$(root_hugo_value '.module.hugoVersion.min')" ]] || return 1

    local tag_count
    tag_count="$(theme_toml_value '.tags | length')"
    (( tag_count >= 8 )) || return 1

    local feature_count
    feature_count="$(theme_toml_value '.features | length')"
    (( feature_count >= 8 )) || return 1

    theme_toml_value '.tags[]' | grep -qx 'responsive' || return 1
    theme_toml_value '.tags[]' | grep -qx 'gallery' || return 1
    theme_toml_value '.tags[]' | grep -qx 'podcast' || return 1
    theme_toml_value '.features[]' | grep -qx 'Podcast and audiobook pages with RSS feeds' || return 1
}
