# shellcheck shell=bash
# ABOUTME: RT-54.15 — when both `attribution=` and `photo=` are set, no <img> appears in the figcaption.

# What user action does this test simulate?
#   The author leaves a legacy `attribution=` in place and adds `photo=` as part of
#   a migration attempt. The user reads the rendered page.
# What would the user observe?
#   No photo. The back-compat path renders only the attribution text.
#
# Relies on the same demo entry as RT-54.14 (which has both attribution and photo set).

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # Find the back-compat figure (the one containing "Oscar Wilde"). Inside it,
    # there must be NO <img class="pull-quote-photo">.
    # Use awk to extract the figure block around the attribution text.
    local backcompat_block
    backcompat_block=$(awk '
        /<figure class="pull-quote/ { capture = $0 ; in_fig = 1 ; next }
        in_fig { capture = capture ORS $0 ; if (/<\/figure>/) { if (capture ~ /Oscar Wilde/) { print capture ; exit } else { in_fig = 0 ; capture = "" } } }
    ' "$page")

    if [[ -z "$backcompat_block" ]]; then
        printf '    no figure containing "Oscar Wilde" found\n' >&2
        return 1
    fi

    if grep -q 'class="pull-quote-photo"' <<< "$backcompat_block"; then
        # shellcheck disable=SC2016
        printf '    found .pull-quote-photo inside the back-compat figure — photo should be ignored when `attribution=` is set\n' >&2
        return 1
    fi
    return 0
}
