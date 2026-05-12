# shellcheck shell=bash
# ABOUTME: RT-54.10 — unresolvable photo (e.g. typo or missing file) omits the <img> from output.

# What user action does this test simulate?
#   The author writes `photo="nonexistent.jpg"` by mistake. The user opens the page.
# What would the user observe?
#   No broken-image placeholder. The attribution renders without a photo.
#
# The demo content includes a quote with photo="missing-file.jpg" that does not
# exist in the page bundle. The shortcode must omit the <img> rather than emit
# a broken reference.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Look for any .pull-quote-photo with src containing "intentionally-missing-file".
    local srcs
    srcs=$(htmlq -f "$page" -a src '.pull-quote-photo' 2>/dev/null)

    if grep -qF "intentionally-missing-file" <<< "$srcs"; then
        printf '    found .pull-quote-photo referencing intentionally-missing-file (should be omitted)\n' >&2
        printf '    srcs:\n%s\n' "$srcs" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
