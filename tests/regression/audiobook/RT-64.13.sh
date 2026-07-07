# shellcheck shell=bash
# ABOUTME: RT-64.13 - make build fails when committed media metadata is missing.

run_test() {
    local out
    out="$(mktemp -t "ff-missing-media-XXXXXX.yaml")"
    rm -f "$out"

    if HUGO_ENVIRONMENT=theme-demo-live make -C "$THEME_ROOT" build FIRST_FOLIO_MEDIA_OUTPUT="$out" >/dev/null 2>&1; then
        rm -f "$out"
        printf '    make build unexpectedly succeeded with missing metadata\n' >&2
        return 1
    fi

    rm -f "$out"
    [[ ! -e "$out" ]]
}
