# shellcheck shell=bash
# ABOUTME: RT-54.36 — back-compat: a page's <title> tag shows .Title even when linkTitle is set.
# ABOUTME: Browser tab and SEO surface the full title; linkTitle is for in-site nav only.

# What user action does this test simulate?
#   The user opens /journal/typography-guide/, looks at the browser tab title
#   (and search engines / link previews use the same <title> tag content).
# What would the user observe?
#   The <title> tag contains the full long .Title, not the short linkTitle.

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local title_tag
    title_tag=$(htmlq -f "$build/journal/typography-guide/index.html" -t 'title' 2>/dev/null)

    # The <title> tag includes the site title suffix in this theme's template,
    # so we use grep -F to match the article-title prefix.
    if grep -qF "A Comprehensive Guide to Typography in the First Folio Theme" <<< "$title_tag"; then
        return 0
    else
        printf '    expected <title> tag to contain the full .Title (back-compat)\n' >&2
        printf '    got: %s\n' "$title_tag" >&2
        return 1
    fi
}
