# ABOUTME: Top-level make targets for the hugo-theme-first-folio theme.
# ABOUTME: `make test` runs regression tests; `make smoke` link-checks the built exampleSite.

SHELL := /usr/bin/env bash
SMOKE_DIR := /tmp/ff-smoke-build

.PHONY: test test-one-off smoke lint help

help:
	@printf 'Available targets:\n'
	@printf '  test          run regression tests (tests/regression/)\n'
	@printf '  test-one-off  run one-off tests (tests/one_off/); use ISSUE=N to filter\n'
	@printf '  smoke         build exampleSite and link-check it with htmltest\n'
	@printf '  lint          shellcheck on test scripts\n'

test: lint
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

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		find tests -name '*.sh' -print0 | xargs -0 shellcheck; \
	else \
		printf 'shellcheck not installed; skipping lint\n'; \
	fi
