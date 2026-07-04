#!/usr/bin/env bash
# ABOUTME: Generate First Folio media metadata for the exampleSite audio demos.
# ABOUTME: Consuming sites can adapt this pre-Hugo build pattern for their own media.
set -euo pipefail
IFS=$'\n\t'

content_files="${FIRST_FOLIO_MEDIA_CONTENT:-exampleSite/content/audiobook-demo/index.md exampleSite/content/podcast-demo/index.md}"
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

mkdir -p "$(dirname "$output_file")"

STATIC_DIR="$static_dir" \
OUTPUT_FILE="$output_file" \
CONTENT_FILES="$content_files" \
ruby <<'RUBY'
require "json"
require "open3"
require "yaml"

static_dir = ENV.fetch("STATIC_DIR")
output_file = ENV.fetch("OUTPUT_FILE")
content_files = ENV.fetch("CONTENT_FILES").split

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

metadata = {}

content_files.each do |content_file|
  book_id, status = Open3.capture2("yq", "--front-matter=extract", ".params.audiobook.id", content_file)
  unless status.success?
    warn "failed to read audiobook id from #{content_file}"
    exit 1
  end

  book_id = book_id.strip
  if book_id.empty? || book_id == "null"
    warn "audiobook metadata requires params.audiobook.id in #{content_file}"
    exit 1
  end

  chapters_json, status = Open3.capture2("yq", "--front-matter=extract", "-o=json", ".params.audiobook.chapters", content_file)
  unless status.success?
    warn "failed to read audiobook chapters from #{content_file}"
    exit 1
  end

  chapters = JSON.parse(chapters_json)
  metadata[book_id] = {}

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
end

File.write(output_file, metadata.to_yaml)
RUBY
