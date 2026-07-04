# shellcheck shell=bash
# ABOUTME: RT-64.9 - Pages workflow builds through the Makefile without probing media.

run_test() {
    local workflow="$THEME_ROOT/.github/workflows/demo-site.yml"

    yq -e '.jobs.build.steps[] | select(.name == "Build exampleSite") | select(.run == "make build")' "$workflow" >/dev/null || return 1
    if yq -e '.jobs.build.steps[] | select((.name // "" | test("(?i)ffprobe|ffmpeg")) or (.run // "" | test("(?i)ffprobe|ffmpeg")))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not install or run ffprobe/ffmpeg during build\n' >&2
        return 1
    fi
}
