# shellcheck shell=bash
# ABOUTME: RT-64.13 - make build generates media metadata only when the data file is missing.

run_test() {
    local out
    out="$(mktemp -t "ff-missing-media-XXXXXX.yaml")"
    rm -f "$out"

    if ! make -C "$THEME_ROOT" ensure-audiobook-metadata FIRST_FOLIO_MEDIA_OUTPUT="$out" >/dev/null; then
        rm -f "$out"
        return 1
    fi

    local length
    length="$(yq '."first-folio-demo-podcast"."episode-1".byteLength' "$out")"
    rm -f "$out"
    [[ "$length" == "64280" ]]
}
