#!/usr/bin/env bash
# ABOUTME: Generate First Folio media metadata for the exampleSite audiobook demo.
# ABOUTME: Consuming sites can adapt this pre-Hugo build pattern for their own media.
set -euo pipefail
IFS=$'\n\t'

content_file="${FIRST_FOLIO_MEDIA_CONTENT:-exampleSite/content/audiobook-demo/index.md}"
static_dir="${FIRST_FOLIO_MEDIA_STATIC_DIR:-exampleSite/static}"
output_file="${FIRST_FOLIO_MEDIA_OUTPUT:-exampleSite/data/first_folio_media.yaml}"

if ! command -v yq >/dev/null 2>&1; then
    printf 'generate-audiobook-metadata requires yq\n' >&2
    exit 1
fi

if ! command -v ffprobe >/dev/null 2>&1; then
    printf 'generate-audiobook-metadata requires ffprobe\n' >&2
    exit 1
fi

book_id="$(yq --front-matter=extract '.params.audiobook.id' "$content_file")"
if [[ -z "$book_id" || "$book_id" == "null" ]]; then
    printf 'audiobook metadata requires params.audiobook.id in %s\n' "$content_file" >&2
    exit 1
fi

mkdir -p "$(dirname "$output_file")"

BOOK_ID="$book_id" \
STATIC_DIR="$static_dir" \
CONTENT_FILE="$content_file" \
OUTPUT_FILE="$output_file" \
ruby <<'RUBY'
require "json"
require "open3"
require "yaml"

book_id = ENV.fetch("BOOK_ID")
static_dir = ENV.fetch("STATIC_DIR")
content_file = ENV.fetch("CONTENT_FILE")
output_file = ENV.fetch("OUTPUT_FILE")

chapters_json, status = Open3.capture2("yq", "--front-matter=extract", "-o=json", ".params.audiobook.chapters", content_file)
unless status.success?
  warn "failed to read audiobook chapters from #{content_file}"
  exit 1
end

def duration_hhmmss(path)
  output, status = Open3.capture2("ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "default=noprint_wrappers=1:nokey=1", path)
  unless status.success?
    warn "ffprobe failed for #{path}"
    exit 1
  end
  seconds = output.to_f.round
  hours = seconds / 3600
  minutes = (seconds % 3600) / 60
  secs = seconds % 60
  format("%02d:%02d:%02d", hours, minutes, secs)
end

chapters = JSON.parse(chapters_json)
metadata = { book_id => {} }

chapters.each do |chapter|
  id = chapter.fetch("id")
  src = chapter.fetch("src")

  unless src.start_with?("/")
    warn "cannot generate local media metadata for non-local src #{src.inspect}"
    exit 1
  end

  local_path = File.join(static_dir, src.delete_prefix("/"))
  unless File.file?(local_path)
    warn "media file not found for #{src}: #{local_path}"
    exit 1
  end

  metadata.fetch(book_id)[id] = {
    "src" => src,
    "byteLength" => File.size(local_path),
    "duration" => duration_hhmmss(local_path)
  }
end

File.write(output_file, metadata.to_yaml)
RUBY
