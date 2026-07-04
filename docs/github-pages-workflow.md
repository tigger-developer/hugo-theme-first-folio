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
- Installs Hugo Extended (latest version)
- Builds the site with `--minify` for production
- Deploys the output to GitHub Pages

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
        env:
          GH_TOKEN: ${{ github.token }}
        run: |
          git init .
          git remote add origin "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git"
          git -c http.extraheader="AUTHORIZATION: bearer ${GH_TOKEN}" fetch --depth=1 origin "$GITHUB_SHA"
          git checkout --detach FETCH_HEAD

      - name: Install Hugo and ffprobe
        run: |
          sudo apt-get update
          sudo apt-get install -y hugo ffmpeg

      - name: Build with Make
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
        run: make build

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

## Custom domain

If you're using a custom domain (e.g. `www.example.com`):

1. Set `baseURL: https://www.example.com/` in your `hugo.yaml`
2. Configure the custom domain in **Settings > Pages** for your repository
3. Configure the DNS record as described in [GitHub's custom domain docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)

GitHub ignores `CNAME` files when publishing Pages from a custom GitHub Actions workflow. `CNAME` files are only required for branch-based Pages publishing.

## ExampleSite Builds

This theme repository deploys its demo from `exampleSite`, not from the repository root. Its workflow checks out the repository with Git, installs `hugo` and `ffmpeg` from apt, sets `HUGO_ENVIRONMENT=theme-demo-live`, and calls `make build`.

The `make build` target intentionally requires `HUGO_ENVIRONMENT` from the caller. The Makefile must not guess the environment name because consuming sites own their Hugo environment names and config directories. For this repository's demo, run:

```sh
HUGO_ENVIRONMENT=theme-demo-live make build
```

That target builds Hugo with `--source exampleSite --destination public`, which writes the deployable artifact to `exampleSite/public`. It uses the committed `exampleSite/data/first_folio_media.yaml` in normal builds. If that file is missing, `make build` generates it with `ffprobe` before running Hugo; refresh it explicitly with `make generate-audiobook-metadata` when demo audio files or chapter source paths change, then commit the updated YAML.

## Hugo modules

If your site uses Hugo modules (rather than git submodules), add a Go setup step before the Hugo build:

```yaml
      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: 'stable'
```
