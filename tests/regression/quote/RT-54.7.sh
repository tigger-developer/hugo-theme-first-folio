# shellcheck shell=bash
# ABOUTME: RT-54.7 — `photo="sample-a.jpg"` resolves to a page-resource URL in the rendered <img src>.

# What user action does this test simulate?
#   The user reads a testimonial whose author has a portrait photo bundled with
#   the page (the shortcode-showcase page bundle contains sample-a.jpg).
# What would the user observe?
#   The portrait appears next to the attribution. The img src points at a URL
#   under the page's permalink path (Hugo's page-resource URL pattern).

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # All .pull-quote-photo src attributes.
    local srcs
    srcs=$(htmlq -f "$page" -a src '.pull-quote-photo' 2>/dev/null)

    # Page-resource URLs for shortcode-showcase will be under /journal/shortcode-showcase/.
    # The filename may be hashed by Hugo image processing, so check the prefix.
    if grep -qE '^/journal/shortcode-showcase/.*\.jpg$' <<< "$srcs"; then
        return 0
    fi
    printf '    expected a .pull-quote-photo src under /journal/shortcode-showcase/\n' >&2
    printf '    srcs found:\n%s\n' "$srcs" | sed 's/^/      /' >&2
    return 1
}
