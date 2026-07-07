# Deploying to GitHub Pages

A ready-to-use GitHub Actions workflow for deploying a Hugo site with the First Folio theme to GitHub Pages.

## Prerequisites

1. In your GitHub repo, go to **Settings > Pages** and set the Source to **GitHub Actions**.
2. Set `baseURL` in your Hugo config, either in the default config or in the environment config used by the workflow.

## Setup

Copy the workflow below into `.github/workflows/hugo-pages.yml` in your repo. Set `HUGO_ENVIRONMENT` to the Hugo environment name your site uses for production Pages builds.

The workflow:

- Triggers on every push to `main` (adjust the branch name if yours differs)
- Can also be triggered manually from the Actions tab
- Builds with a pinned Hugo container
- Builds the site with `--minify` for production
- Deploys the output to GitHub Pages

If your site uses generated podcast or audiobook metadata, add a pre-build step that verifies the committed metadata is present. Do not run media probes during Pages deploys; generate metadata locally, commit it, and let CI fail early when the committed data is missing.

## Workflow

```yaml
name: Deploy Hugo site to Pages

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build Hugo
        env:
          HUGO_ENVIRONMENT: production
          HUGO_IMAGE: hugomods/hugo:debian-0.161.1@sha256:b65563ec4d103289c6c1e0a26875036bad780702b2613825f8d4c02f63c7711a
        run: |
          docker run --rm \
            -v "$PWD:/src" \
            -w /src \
            -e HUGO_CACHEDIR=/tmp/hugo_cache \
            -e HUGO_ENVIRONMENT="$HUGO_ENVIRONMENT" \
            "$HUGO_IMAGE" \
            hugo --source . --destination public --environment "$HUGO_ENVIRONMENT" --gc --minify

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v5
        with:
          path: ./public

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v5
```

For this theme repository's demo workflow, the metadata guard is:

```yaml
      - name: Verify committed media metadata
        run: make verify-audiobook-metadata
```

## Custom domain

If you're using a custom domain (e.g. `www.example.com`):

1. Set `baseURL: https://www.example.com/` in your `hugo.yaml`
2. Configure the custom domain in **Settings > Pages** for your repository
3. Configure the DNS record as described in [GitHub's custom domain docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)

GitHub ignores `CNAME` files when publishing Pages from a custom GitHub Actions workflow. `CNAME` files are only required for branch-based Pages publishing.

## ExampleSite Builds

This theme repository deploys its demo from `exampleSite`, not from the repository root. Its workflow uses GitHub's official checkout action, verifies committed media metadata with `make verify-audiobook-metadata`, sets `HUGO_ENVIRONMENT=theme-demo-live`, and runs Hugo inside a pinned Hugo container. GitHub's official actions may use Node internally as Actions runtime plumbing; Node is not a project dependency and is not used by the Hugo build.

The `make build` target intentionally requires `HUGO_ENVIRONMENT` from the caller. The Makefile must not guess the environment name because consuming sites own their Hugo environment names and config directories. For this repository's demo, run:

```sh
HUGO_ENVIRONMENT=theme-demo-live make build
```

The demo workflow builds Hugo with `--source exampleSite --destination public`, which writes the deployable artifact to `exampleSite/public`. It requires the committed `exampleSite/data/first_folio_media.yaml`; CI fails if that file is missing. Refresh it explicitly with `make generate-audiobook-metadata` when demo audio files or chapter source paths change, then commit the updated YAML before pushing. GitHub Pages deploys do not run `ffprobe`.

## Hugo modules

If your site uses Hugo modules (rather than git submodules), add a Go setup step before the Hugo build:

```yaml
      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: 'stable'
```
