# shellcheck shell=bash
# ABOUTME: RT-54.23 — `list_style: prose` page renders signpost_footer frontmatter via the .signpost-footer partial.

# What user action does this test simulate?
#   The user reads /profile/ down to the bottom and sees a footer CTA.
# What would the user observe?
#   An element with class containing "signpost-footer" (or similar) and the text "BOTTOM-CTA".

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    # The signpost-footer partial renders <div class="signpost signpost-footer">.
    local footer_html
    footer_html=$(htmlq -f "$page" 'div.signpost-footer' 2>/dev/null)

    if [[ -z "$footer_html" ]]; then
        printf '    no div.signpost-footer element found in /profile/index.html\n' >&2
        return 1
    fi
    if ! grep -qF "BOTTOM-CTA" <<< "$footer_html"; then
        printf '    div.signpost-footer present but does not contain "BOTTOM-CTA"\n' >&2
        printf '    footer HTML:\n%s\n' "$footer_html" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
