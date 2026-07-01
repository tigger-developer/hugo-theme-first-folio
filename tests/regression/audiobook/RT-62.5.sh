# shellcheck shell=bash
# ABOUTME: RT-62.5 - demo m4a files are copied into the repository.

run_test() {
    local audio_dir="$THEME_ROOT/exampleSite/static/audio/audiobook-demo"
    [[ -f "$audio_dir/episode-1.m4a" ]] || return 1
    [[ -f "$audio_dir/episode-2.m4a" ]] || return 1
    [[ -f "$audio_dir/episode-3.m4a" ]] || return 1

    if grep -R -qF '/Users/tigger/scratch/yapcast' "$THEME_ROOT/exampleSite"; then
        printf '    exampleSite must not reference the scratch audio source path\n' >&2
        return 1
    fi
}
