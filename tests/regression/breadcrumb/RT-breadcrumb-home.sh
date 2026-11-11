# shellcheck shell=bash
# ABOUTME: Top-level articles link to the theme's localized Home label in their breadcrumb.
# ABOUTME: Sectioned articles retain their section as the first breadcrumb segment.

run_test() {
    local build custom_build
    if ! build=$(build_fixture breadcrumb-top-level); then
        return 1
    fi
    if ! custom_build=$(build_fixture breadcrumb-custom-label); then
        return 1
    fi

    local top_level_text top_level_href sectioned_text custom_text
    top_level_text=$(htmlq -f "$build/article/index.html" -t '.breadcrumb-section:first-child')
    top_level_href=$(htmlq -f "$build/article/index.html" -a href '.breadcrumb-section:first-child')
    sectioned_text=$(htmlq -f "$build/journal/sectioned/index.html" -t '.breadcrumb-section:first-child')
    custom_text=$(htmlq -f "$custom_build/article/index.html" -t '.breadcrumb-section:first-child')

    [[ "$top_level_text" == "Home" ]] || return 1
    [[ "$top_level_href" == "/" ]] || return 1
    [[ "$sectioned_text" == "Journal" ]] || return 1
    [[ "$custom_text" == "Start" ]]
}
