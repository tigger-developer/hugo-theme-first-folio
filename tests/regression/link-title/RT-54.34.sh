# shellcheck shell=bash
# ABOUTME: RT-54.34 — back-compat: pages without linkTitle continue to show their .Title in nav contexts.
# ABOUTME: Hugo's .LinkTitle falls back to .Title when linkTitle frontmatter is unset.

# What user action does this test simulate?
#   The user loads /journal/typography-guide/ which has typography-guide's own
#   related-articles strip. That strip contains pages from journal/ that share tags,
#   most of which DO NOT have linkTitle set (e.g. "The Background Image Layout",
#   "Configuring Dark Mode"). Reads the related-articles list.
# What would the user observe?
#   Pages without linkTitle appear with their full .Title — i.e. the swap to
#   .LinkTitle is a no-op for unset cases (Hugo built-in fallback).

run_test() {
    local build
    if ! build=$(build_examplesite); then
        return 1
    fi

    local related_text
    related_text=$(htmlq -f "$build/journal/typography-guide/index.html" -t '.related-articles a' 2>/dev/null)

    # "The Background Image Layout" is the title of a journal page with no linkTitle.
    # It must continue to appear in nav contexts as its full title under the swap.
    if grep -qFx "The Background Image Layout" <<< "$related_text"; then
        return 0
    else
        printf '    expected "The Background Image Layout" (back-compat: page without linkTitle keeps .Title)\n' >&2
        printf '    got:\n%s\n' "$related_text" | sed 's/^/      /' >&2
        return 1
    fi
}
