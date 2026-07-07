# ABOUTME: Top-level make targets for the hugo-theme-first-folio theme.
# ABOUTME: `make test` runs regression tests; `make smoke` link-checks the built exampleSite.

SHELL := /usr/bin/env bash
SMOKE_DIR := /tmp/ff-smoke-build
HUGO_BIND ?= 127.0.0.1
HUGO_PORT ?= 1313
FIRST_FOLIO_MEDIA_CONTENT ?= exampleSite/content/audiobook-demo/index.md exampleSite/content/podcast-demo/index.md
FIRST_FOLIO_MEDIA_STATIC_DIR ?= exampleSite/static
FIRST_FOLIO_MEDIA_OUTPUT ?= exampleSite/data/first_folio_media.yaml

.PHONY: build verify-audiobook-metadata ensure-audiobook-metadata generate-audiobook-metadata test test-one-off smoke serve lint help

help:
	@printf 'Available targets:\n'
	@printf '  build         build exampleSite for deployment; requires committed media metadata\n'
	@printf '  verify-audiobook-metadata  fail if committed exampleSite media metadata is missing\n'
	@printf '  ensure-audiobook-metadata  generate exampleSite media metadata when the committed file is missing\n'
	@printf '  generate-audiobook-metadata  explicitly refresh generated media facts for the exampleSite audio demos\n'
	@printf '  test          run regression tests (tests/regression/)\n'
	@printf '  test-one-off  run one-off tests (tests/one_off/); use ISSUE=N to filter\n'
	@printf '  smoke         build exampleSite and link-check it with htmltest\n'
	@printf '  serve         run hugo server for exampleSite; override HUGO_BIND/HUGO_PORT as needed\n'
	@printf '  lint          shellcheck on test scripts\n'

build: verify-audiobook-metadata
	@if [ -z "$${HUGO_ENVIRONMENT:-}" ]; then \
		printf 'HUGO_ENVIRONMENT is required for make build\n' >&2; \
		exit 2; \
	fi
	@hugo --source exampleSite --destination public --environment "$(HUGO_ENVIRONMENT)" --minify

verify-audiobook-metadata:
	@if [ ! -s "$(FIRST_FOLIO_MEDIA_OUTPUT)" ]; then \
		printf '%s is missing; run make generate-audiobook-metadata and commit it before building\n' "$(FIRST_FOLIO_MEDIA_OUTPUT)" >&2; \
		exit 2; \
	fi

ensure-audiobook-metadata:
	@if [ ! -s "$(FIRST_FOLIO_MEDIA_OUTPUT)" ]; then \
		printf '%s is missing; generating media metadata with ffprobe\n' "$(FIRST_FOLIO_MEDIA_OUTPUT)" >&2; \
		$(MAKE) generate-audiobook-metadata; \
	fi

generate-audiobook-metadata:
	@bash scripts/generate-audiobook-metadata.sh

test: lint
	@bash tests/regression/run.sh

test-one-off:
ifdef ISSUE
	@find tests/one_off -name "OT-$(ISSUE).*.sh" -print -exec bash {} \;
else
	@find tests/one_off -name "OT-*.sh" -print -exec bash {} \;
endif

smoke: verify-audiobook-metadata
	@if [ -d "$(SMOKE_DIR)" ]; then trash "$(SMOKE_DIR)"; fi
	@hugo --quiet --source exampleSite --destination "$(SMOKE_DIR)"
	@htmltest

serve:
	@hugo server --source exampleSite --bind "$(HUGO_BIND)" --port "$(HUGO_PORT)" --baseURL "http://$(HUGO_BIND):$(HUGO_PORT)/" --disableFastRender

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		find tests -name '*.sh' -execdir shellcheck -x {} +; \
	else \
		printf 'shellcheck not installed; skipping lint\n'; \
	fi
