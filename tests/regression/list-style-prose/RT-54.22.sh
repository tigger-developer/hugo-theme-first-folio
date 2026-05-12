# shellcheck shell=bash
# ABOUTME: RT-54.22 — `list_style: prose` page renders signpost frontmatter via the .signpost partial.

# What user action does this test simulate?
#   The user opens /profile/ (which sets `signpost: {text: TOP-CTA, url: /contact/}`)
#   and sees a prominent CTA near the top of the page.
# What would the user observe?
#   An element with class "signpost" (not signpost-footer) containing the text "TOP-CTA".

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/profile/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    # The signpost partial wraps in <div class="signpost">.
    local signpost_html
    signpost_html=$(htmlq -f "$page" 'div.signpost' 2>/dev/null)

    if [[ -z "$signpost_html" ]]; then
        printf '    no div.signpost element found in /profile/index.html\n' >&2
        return 1
    fi
    if ! grep -qF "TOP-CTA" <<< "$signpost_html"; then
        printf '    div.signpost present but does not contain "TOP-CTA"\n' >&2
        printf '    signpost HTML:\n%s\n' "$signpost_html" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
