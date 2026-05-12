# shellcheck shell=bash
# ABOUTME: RT-54.14 — when both `attribution=` and structured `name=` are set, `attribution=` wins (back-compat path used).

# What user action does this test simulate?
#   The author sets BOTH `attribution="Oscar Wilde"` (legacy) AND `name="Imposter"` (new)
#   on the same quote. The user reads the rendered page.
# What would the user observe?
#   The figcaption shows "Oscar Wilde" — the structured fields are ignored when
#   `attribution=` is present. This is the documented back-compat rule.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local figcaptions
    figcaptions=$(htmlq -f "$page" -t '.pull-quote figcaption' 2>/dev/null)

    # The demo content sets attribution="Oscar Wilde" + name="Should Be Ignored".
    # We expect to see "Oscar Wilde" and NOT see "Should Be Ignored".
    if ! grep -qF "Oscar Wilde" <<< "$figcaptions"; then
        printf '    expected figcaption to contain "Oscar Wilde"\n' >&2
        return 1
    fi
    if grep -qF "Should Be Ignored" <<< "$figcaptions"; then
        # shellcheck disable=SC2016
        printf '    figcaption contains "Should Be Ignored" — structured fields should be ignored when `attribution=` is set\n' >&2
        return 1
    fi
    return 0
}
