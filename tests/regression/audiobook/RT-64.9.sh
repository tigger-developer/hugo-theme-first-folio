# shellcheck shell=bash
# ABOUTME: RT-64.9 - Pages workflow uses official checkout and a pinned Hugo container.

run_test() {
    local workflow="$THEME_ROOT/.github/workflows/demo-site.yml"

    yq -e '.jobs.build.steps[] | select(.name == "Checkout") | select(.uses == "actions/checkout@v4")' "$workflow" >/dev/null || return 1
    if yq -e '.jobs.build.steps[] | select(.run // "" | contains("git init"))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not hand-roll checkout with git init\n' >&2
        return 1
    fi
    if yq -e '.jobs.build.steps[] | select(.uses // "" | test("^actions/configure-pages@"))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not run unused configure-pages action\n' >&2
        return 1
    fi
    if yq -e '.jobs.build.steps[] | select(.run // "" | contains("ffprobe") or contains("apt-get install"))' "$workflow" >/dev/null 2>/dev/null; then
        printf '    Pages workflow should not install or run ffprobe during deploy\n' >&2
        return 1
    fi
    yq -e '.jobs.build.steps[] | select(.name == "Verify committed media metadata") | select(.run == "make verify-audiobook-metadata")' "$workflow" >/dev/null || return 1
    yq -e '.jobs.build.steps[] | select(.name == "Build exampleSite") | select(.env.HUGO_IMAGE | test("^hugomods/hugo:debian-0\\.161\\.1@sha256:[0-9a-f]{64}$")) | select(.run | contains("docker run --rm")) | select(.run | contains("hugo --source exampleSite --destination public"))' "$workflow" >/dev/null
}
