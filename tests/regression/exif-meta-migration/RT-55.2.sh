# shellcheck shell=bash
# ABOUTME: RT-55.2 — gallery shortcode surfaces EXIF DocumentName and ImageDescription via the .Meta.Exif API.
# ABOUTME: End-to-end verification that the #55 migration's field-access shape is correct.

# What user action does this test simulate?
#   A site author tags their gallery images with EXIF DocumentName ("Dunmore Head")
#   and ImageDescription ("Late afternoon light on the cliffs..."), drops them in a
#   page bundle with gallery: true and {{< gallery >}} in the body, and visits
#   the rendered gallery page.
# What would the user observe?
#   The rendered <img alt=...> for that image contains the DocumentName and
#   ImageDescription — Hugo's image-processing has read them via .Meta.Exif and
#   the gallery shortcode has surfaced them as title/caption.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/photography/coastal-walks/index.html"

    if [[ ! -f "$page" ]]; then
        printf '    expected built page at %s\n' "$page" >&2
        return 1
    fi

    # All <img> alt attributes in the gallery.
    local alts
    alts=$(htmlq -f "$page" -a alt 'img' 2>/dev/null)

    # The Dunmore Head image carries DocumentName "Dunmore Head" and
    # ImageDescription "Late afternoon light on the cliffs at Dunmore Head, west Kerry."
    # The gallery shortcode builds alt as "$title - $caption" when both are set.
    local -a failures=()
    if ! grep -qF "Dunmore Head" <<< "$alts"; then
        failures+=("expected an <img alt=...> containing 'Dunmore Head' (DocumentName)")
    fi
    if ! grep -qF "Late afternoon light on the cliffs" <<< "$alts"; then
        failures+=("expected an <img alt=...> containing the ImageDescription text")
    fi

    if (( ${#failures[@]} > 0 )); then
        printf '    %s\n' "${failures[@]}" >&2
        printf '    alts found on /photography/coastal-walks/index.html:\n%s\n' "$alts" | sed 's/^/      /' >&2
        return 1
    fi
    return 0
}
