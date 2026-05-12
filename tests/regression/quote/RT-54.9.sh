# shellcheck shell=bash
# ABOUTME: RT-54.9 — `photo="https://..."` absolute URL passes through verbatim into the <img src>.

# What user action does this test simulate?
#   The user reads a testimonial whose photo is hosted on a CDN (an absolute URL).
# What would the user observe?
#   The portrait appears, loaded from the external URL exactly as authored.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local srcs
    srcs=$(htmlq -f "$page" -a src '.pull-quote-photo' 2>/dev/null)

    # The demo content will set photo="https://example.com/portrait.jpg" — match that.
    if grep -qFx "https://example.com/portrait.jpg" <<< "$srcs"; then
        return 0
    fi
    printf '    expected a .pull-quote-photo src "https://example.com/portrait.jpg" (absolute URL verbatim)\n' >&2
    printf '    srcs found:\n%s\n' "$srcs" | sed 's/^/      /' >&2
    return 1
}
