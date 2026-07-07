#!/usr/bin/env bash
# ABOUTME: OT-65.3 - verify the latest public tag contains Hugo portal artefacts.
# ABOUTME: Run after tagging the release intended for portal submission.
set -euo pipefail

tag="$(git describe --tags --abbrev=0)"

for path in theme.toml hugo.yaml README.md images/screenshot.png images/tn.png; do
    if ! git cat-file -e "$tag:$path"; then
        printf '%s is missing from %s\n' "$path" "$tag" >&2
        exit 1
    fi
done

demo="$(git show "$tag:theme.toml" | yq -p toml -r '.demosite')"
if [[ "$demo" != "https://demo.theme.tadg.ie/" ]]; then
    printf 'tag %s has stale demosite %s\n' "$tag" "$demo" >&2
    exit 1
fi
