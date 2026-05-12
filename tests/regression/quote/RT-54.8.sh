# shellcheck shell=bash
# ABOUTME: RT-54.8 — `photo="/some/site-root/path.jpg"` resolves to a site-root URL (no page-permalink prefix).

# What user action does this test simulate?
#   The user reads a testimonial whose photo lives outside the page bundle (e.g.
#   a shared portraits folder at site root: /icons/chevron-right-thick.svg).
# What would the user observe?
#   The portrait appears at the site-root path, exactly as specified.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    local srcs
    srcs=$(htmlq -f "$page" -a src '.pull-quote-photo' 2>/dev/null)

    # Expect at least one src matching the site-root example used in the demo content.
    # Use icons/chevron-right-thick.svg — it exists at site root and is a known asset.
    if grep -qFx "/icons/chevron-right-thick.svg" <<< "$srcs"; then
        return 0
    fi
    printf '    expected a .pull-quote-photo src "/icons/chevron-right-thick.svg" (site-root path)\n' >&2
    printf '    srcs found:\n%s\n' "$srcs" | sed 's/^/      /' >&2
    return 1
}
