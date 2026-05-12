# shellcheck shell=bash
# ABOUTME: RT-54.3 — quote with `name=` only renders a .pull-quote-name with the name, no .pull-quote-role secondary line.

# What user action does this test simulate?
#   The user reads the structured-attribution demo with only a `name` set (no role / org).
# What would the user observe?
#   The speaker's name appears alone; no role or org line below.

run_test() {
    local build
    if ! build=$(build_examplesite); then return 1; fi
    local page="$build/journal/shortcode-showcase/index.html"

    # A .pull-quote with .pull-quote-name "Frodo Baggins" and no .pull-quote-role sibling.
    # Hugo wraps each quote; we look at the parent figcaption to scope.
    local name_only_found=0
    # Iterate figcaptions, find one with the expected name and no .pull-quote-role.
    local figcaptions
    figcaptions=$(htmlq -f "$page" -p '.pull-quote-attribution' 2>/dev/null)

    if grep -q 'pull-quote-name">Frodo Baggins<' <<< "$figcaptions"; then
        # Frodo's figcaption block should not contain .pull-quote-role
        # awk extracts the block around the match.
        local frodo_block
        frodo_block=$(awk '/pull-quote-name">Frodo Baggins</{flag=1} flag{print; if (/<\/figcaption>/){exit}}' <<< "$figcaptions")
        if ! grep -q 'pull-quote-role' <<< "$frodo_block"; then
            name_only_found=1
        fi
    fi

    if (( name_only_found == 1 )); then
        return 0
    fi
    printf '    expected a .pull-quote-attribution with .pull-quote-name "Frodo Baggins" and no .pull-quote-role\n' >&2
    printf '    attributions found:\n%s\n' "$figcaptions" | sed 's/^/      /' >&2
    return 1
}
