# shellcheck shell=bash
# ABOUTME: RT-64.9 - Pages workflow uses shell checkout, apt Hugo/ffmpeg, and Make.

run_test() {
    local workflow="$THEME_ROOT/.github/workflows/demo-site.yml"

    yq -e '.jobs.build.steps[] | select(.name == "Checkout") | select(.run | contains("git init")) | select(.run | contains("git checkout --detach FETCH_HEAD"))' "$workflow" >/dev/null || return 1
    if yq -e '.jobs.build.steps[] | select(.uses // "" | test("^actions/checkout@"))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not use actions/checkout\n' >&2
        return 1
    fi
    if yq -e '.jobs.build.steps[] | select(.uses // "" | test("^actions/configure-pages@"))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not run unused configure-pages action\n' >&2
        return 1
    fi
    yq -e '.jobs.build.steps[] | select(.name == "Install Hugo and ffprobe") | select(.run | contains("apt-get install -y hugo ffmpeg"))' "$workflow" >/dev/null || return 1
    yq -e '.jobs.build.steps[] | select(.name == "Build exampleSite") | select(.run == "make build")' "$workflow" >/dev/null
}
