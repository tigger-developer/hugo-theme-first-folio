# shellcheck shell=bash
# ABOUTME: RT-54.1 — back-compat: a quote with only `attribution=` set renders a figcaption containing that text.

# What user action does this test simulate?
#   The user opens /journal/shortcode-showcase/, reads the existing back-compat
#   quote example with attribution="Oscar Wilde".
# What would the user observe?
#   The pull-quote's figcaption contains the attribution text.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local figcaptions
    figcaptions=$(htmlq -f "$page" -t '.pull-quote figcaption' 2>/dev/null)

    if grep -qF "Oscar Wilde" <<< "$figcaptions"; then
        return 0
    else
        printf '    expected a .pull-quote figcaption containing "Oscar Wilde"\n' >&2
        printf '    figcaptions found:\n%s\n' "$figcaptions" | sed 's/^/      /' >&2
        return 1
    fi
}
