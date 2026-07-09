# shellcheck shell=bash
# ABOUTME: RT-65.4 - rendered README exposes current public demo and compatibility copy.

run_test() {
    local out
    out="$(mktemp "$AGENT_TMP/ff-theme-readme-XXXXXX.html")"
    pandoc "$THEME_ROOT/README.md" --from gfm --to html --output "$out"

    local links
    links="$(htmlq -f "$out" -a href 'a[href]')"
    if ! grep -qx 'https://demo.theme.tadg.ie' <<< "$links"; then
        rm -f "$out"
        return 1
    fi
    if grep -q 'first-folio.demo.lobb.ie' "$out"; then
        rm -f "$out"
        return 1
    fi
    local headings
    headings="$(htmlq -f "$out" 'h2,h3')"
    if ! grep -q 'Compatibility' <<< "$headings"; then
        rm -f "$out"
        return 1
    fi
    local compatibility
    compatibility="$(htmlq -f "$out" '#compatibility' '+ p')"
    if ! grep -q 'Hugo Extended' <<< "$compatibility"; then
        rm -f "$out"
        return 1
    fi
    if ! grep -q '0.155.0' <<< "$compatibility"; then
        rm -f "$out"
        return 1
    fi

    rm -f "$out"
}
