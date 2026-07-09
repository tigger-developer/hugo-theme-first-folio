# shellcheck shell=bash
# ABOUTME: RT-55.1 — Hugo build emits no `Image.Exif was deprecated` warning.
# ABOUTME: The theme's gallery shortcode has been migrated to Image.Meta (Hugo v0.155+).

# What user action does this test simulate?
#   The user runs `hugo` or `hugo server -s exampleSite` and watches stderr for warnings.
# What would the user observe?
#   No "Image.Exif was deprecated in Hugo v0.155.0" warning. The theme is now using
#   the supported Image.Meta interface.

run_test() {
    local tmp_out tmp_err
    tmp_out="$(mktemp -d "$AGENT_TMP/ff-exif-XXXXXX")"
    tmp_err="$(mktemp "$AGENT_TMP/ff-exif-stderr-XXXXXX")"
    trap 'rm -rf "$tmp_out" "$tmp_err"' RETURN

    hugo --source "$THEME_ROOT/exampleSite" --destination "$tmp_out" --logLevel warn >/dev/null 2>"$tmp_err"
    local rc=$?

    if (( rc != 0 )); then
        printf '    hugo build failed (exit %d):\n%s\n' "$rc" "$(cat "$tmp_err")" | sed 's/^/      /' >&2
        return 1
    fi

    # Two anti-patterns to guard against: the .Exif deprecation specifically,
    # plus any future regression that re-introduces it. Fail if either string appears.
    if grep -qF "Image.Exif was deprecated" "$tmp_err"; then
        printf '    Image.Exif deprecation warning still present in stderr — theme is using the legacy API\n' >&2
        grep "Image.Exif" "$tmp_err" | sed 's/^/      /' >&2
        return 1
    fi

    return 0
}
