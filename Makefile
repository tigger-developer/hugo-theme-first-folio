# ABOUTME: Top-level make targets for the hugo-theme-first-folio theme.
# ABOUTME: `make test` runs regression tests; `make smoke` link-checks the built exampleSite.

SHELL := /usr/bin/env bash
SMOKE_DIR := /tmp/ff-smoke-build
PLAYWRIGHT_BROWSERS_PATH ?= $(CURDIR)/.agent/tmp/ms-playwright
HUGO_BIND ?= 127.0.0.1
HUGO_PORT ?= 1313

.PHONY: test test-one-off smoke serve lint node-deps help

help:
	@printf 'Available targets:\n'
	@printf '  test          run regression tests (tests/regression/)\n'
	@printf '  test-one-off  run one-off tests (tests/one_off/); use ISSUE=N to filter\n'
	@printf '  smoke         build exampleSite and link-check it with htmltest\n'
	@printf '  serve         run hugo server for exampleSite; override HUGO_BIND/HUGO_PORT as needed\n'
	@printf '  lint          shellcheck on test scripts\n'

test: lint node-deps
	@bash tests/regression/run.sh

test-one-off:
ifdef ISSUE
	@find tests/one_off -name "OT-$(ISSUE).*.sh" -print -exec bash {} \;
else
	@find tests/one_off -name "OT-*.sh" -print -exec bash {} \;
endif

smoke:
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

node-deps:
	@if [ -f package-lock.json ] && [ ! -d node_modules/@playwright/test ]; then \
		npm ci; \
	fi
	@if [ -d node_modules/@playwright/test ] && ! find "$(PLAYWRIGHT_BROWSERS_PATH)" -maxdepth 1 -name 'chromium*' -type d 2>/dev/null | grep -q .; then \
		mkdir -p "$(PLAYWRIGHT_BROWSERS_PATH)"; \
		PLAYWRIGHT_BROWSERS_PATH="$(PLAYWRIGHT_BROWSERS_PATH)" npm exec -- playwright install chromium; \
	fi
