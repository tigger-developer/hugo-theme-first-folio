# shellcheck shell=bash
# ABOUTME: RT-54.11 — unresolvable photo causes Hugo to emit a stderr warning naming the offending filename.

# What user action does this test simulate?
#   The author runs `hugo` (or `hugo server`) and watches stderr for build warnings.
#   With a typo'd `photo="missing-file.jpg"` in the demo content, the build should
#   warn so the typo is noticed.
# What would the user observe?
#   A WARN line on stderr mentioning "missing-file.jpg" — directly visible in the
#   build output, not buried in HTML.
#
# This test does its own fresh build (not via build_examplesite) so we can capture
# stderr. Build_examplesite swallows stderr to avoid noise during normal RT runs.

run_test() {
    local tmp_out tmp_err
    tmp_out="$(mktemp -d "$AGENT_TMP/ff-warnf-XXXXXX")"
    tmp_err="$(mktemp "$AGENT_TMP/ff-warnf-stderr-XXXXXX")"
    trap 'rm -rf "$tmp_out" "$tmp_err"' RETURN

    hugo --source "$THEME_ROOT/exampleSite" --destination "$tmp_out" --logLevel warn >/dev/null 2>"$tmp_err"
    local rc=$?

    if (( rc != 0 )); then
        printf '    hugo build failed (exit %d):\n%s\n' "$rc" "$(cat "$tmp_err")" | sed 's/^/      /' >&2
        return 1
    fi

    if grep -qF "intentionally-missing-file.jpg" "$tmp_err"; then
        return 0
    fi
    printf '    expected stderr WARN mentioning intentionally-missing-file.jpg\n' >&2
    printf '    stderr was:\n%s\n' "$(cat "$tmp_err")" | sed 's/^/      /' >&2
    return 1
}
