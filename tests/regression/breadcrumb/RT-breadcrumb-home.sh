# shellcheck shell=bash
# ABOUTME: Article headers prioritize breadcrumbs while presenting linked tags alongside them.
# ABOUTME: Top-level Home localization and hideTags remain available to consuming sites.

run_test() {
    local build custom_build
    if ! build=$(build_fixture breadcrumb-top-level); then
        return 1
    fi
    if ! custom_build=$(build_fixture breadcrumb-custom-label); then
        return 1
    fi

    local top_level_text top_level_href sectioned_text custom_text header_tags
    top_level_text=$(htmlq -f "$build/article/index.html" -t '.breadcrumb-section:first-child')
    top_level_href=$(htmlq -f "$build/article/index.html" -a href '.breadcrumb-section:first-child')
    sectioned_text=$(htmlq -f "$build/journal/sectioned/index.html" -t '.breadcrumb-section:first-child')
    custom_text=$(htmlq -f "$custom_build/article/index.html" -t '.breadcrumb-section:first-child')
    header_tags=$(htmlq -f "$build/article/index.html" -t '.article-header-tags a')

    [[ "$top_level_text" == "Home" ]] || return 1
    [[ "$top_level_href" == "/" ]] || return 1
    [[ "$sectioned_text" == "Journal" ]] || return 1
    [[ "$custom_text" == "Start" ]] || return 1
    grep -qFx 'accessibility' <<< "$header_tags" || return 1
    grep -qFx 'intelligent-machines' <<< "$header_tags" || return 1
    [[ "$(htmlq -f "$build/article/index.html" -a aria-label '.article-header-tags')" == "Article tags" ]] || return 1
    [[ -z "$(htmlq -f "$build/hidden-tags/index.html" '.tags-nav')" ]] || return 1
    [[ -n "$(htmlq -f "$build/article/index.html" '.article-footer-tags')" ]]
}
