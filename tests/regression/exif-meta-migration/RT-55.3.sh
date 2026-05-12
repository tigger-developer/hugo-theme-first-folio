# shellcheck shell=bash
# ABOUTME: RT-55.3 — gallery shortcode renders the EXIF DocumentName as a visible title under each thumbnail.
# ABOUTME: Distinct from the alt-attribute / lightbox data: this is the visible-in-grid title.

# What user action does this test simulate?
#   The user visits a gallery page and looks at the thumbnails. Each image's
#   title (from EXIF DocumentName or frontmatter resource params.title) appears
#   visibly below the thumbnail — not just in the lightbox overlay when clicked.
# What would the user observe?
#   A <span class="gallery-item-title"> element next to each <img>, containing
#   the title text.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/photography/coastal-walks/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    local titles
    titles=$(htmlq -f "$page" -t '.gallery-item-title' 2>/dev/null)

    if [[ -z "$titles" ]]; then
        printf '    no .gallery-item-title elements found on /photography/coastal-walks/\n' >&2
        printf '    EXIF DocumentName values are present but not surfacing visibly under thumbnails\n' >&2
        return 1
    fi

    # At least the Dunmore Head title (DocumentName of coastal-1.jpg) should appear.
    if ! grep -qFx "Dunmore Head" <<< "$titles"; then
        printf '    expected "Dunmore Head" among .gallery-item-title texts\n' >&2
        printf '    titles found:\n%s\n' "$titles" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
