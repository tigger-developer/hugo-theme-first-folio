#!/usr/bin/env bash
# ABOUTME: OT-65.1 - verify the external Hugo themes.txt contribution is sorted.
# ABOUTME: Set THEME_PORTAL_BUILDER_DIR to a local clone of gohugoio/hugoThemesSiteBuilder.
set -euo pipefail

repo="${THEME_PORTAL_BUILDER_DIR:-}"
if [[ -z "$repo" || ! -d "$repo/.git" ]]; then
    printf 'THEME_PORTAL_BUILDER_DIR must point at a local hugoThemesSiteBuilder clone\n' >&2
    exit 2
fi

themes_file="$repo/themes.txt"
theme_url="github.com/tadg-paul/hugo-theme-first-folio"

if [[ ! -f "$themes_file" ]]; then
    printf 'themes.txt not found in %s\n' "$repo" >&2
    exit 1
fi

if [[ "$(grep -cxF "$theme_url" "$themes_file")" != "1" ]]; then
    printf '%s must appear exactly once in themes.txt\n' "$theme_url" >&2
    exit 1
fi

if ! LC_ALL=C sort -c "$themes_file"; then
    printf 'themes.txt is not lexicographically sorted\n' >&2
    exit 1
fi

git -C "$repo" diff -- themes.txt | grep -qF "+$theme_url"
