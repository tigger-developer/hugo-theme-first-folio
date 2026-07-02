# Deploying to GitHub Pages

A ready-to-use GitHub Actions workflow for deploying a Hugo site with the First Folio theme to GitHub Pages.

## Prerequisites

1. In your GitHub repo, go to **Settings > Pages** and set the Source to **GitHub Actions**.
2. Set `baseURL` in your `hugo.yaml`, or leave it unset - the workflow infers it from the Pages configuration automatically.

## Setup

Copy the workflow below into `.github/workflows/hugo-pages.yml` in your repo. No other configuration is needed.

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
        uses: actions/checkout@v4

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: 'latest'
          extended: true

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v6

      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
        run: |
          hugo \
            --environment production \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"

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

## Hugo modules

If your site uses Hugo modules (rather than git submodules), add a Go setup step before the Hugo build:

```yaml
      - name: Setup Go
        uses: actions/setup-go@v5
        with:
          go-version: 'stable'
```
