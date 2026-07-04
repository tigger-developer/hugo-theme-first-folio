# shellcheck shell=bash
# ABOUTME: RT-64.9 - Pages workflow installs ffprobe and builds through the Makefile.

run_test() {
    local workflow="$THEME_ROOT/.github/workflows/demo-site.yml"

    yq -e '.jobs.build.steps[] | select(.name == "Install ffprobe") | select(.run | contains("ffmpeg"))' "$workflow" >/dev/null || return 1
    yq -e '.jobs.build.steps[] | select(.name == "Build exampleSite") | select(.run == "make build")' "$workflow" >/dev/null
}
