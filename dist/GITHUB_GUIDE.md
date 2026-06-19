# GitHub Upload Guide

## Step 1: Download the tarball

Copy `rumbod-cli-pc.tar.gz` to your PC.

## Step 2: Upload to GitHub

```bash
# Create a new repository on GitHub (https://github.com/new)
# Name: rumbod-cli

# Clone it locally
git clone https://github.com/YOUR_USERNAME/rumbod-cli.git
cd rumbod-cli

# Extract the tarball
tar xzf /path/to/rumbod-cli-pc.tar.gz

# Stage everything
git add -A
git commit -m "feat: initial release v0.1.0"
git tag v0.1.0
git push origin main --tags
```

## Step 3: Enable GitHub Pages (optional)

Go to repo → Settings → Pages → Source: GitHub Actions
Add this workflow:

```yaml
# .github/workflows/pages.yml
name: Deploy docs
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: mkdir -p _site && cp README.md _site/
      - uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./_site
```

## Step 4: Test the one-liner from raw GitHub

```bash
# After pushing, test the install.sh one-liner:
bash -c "$(curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/rumbod-cli/main/install.sh)"
```

## Step 5: Create a GitHub Release

```bash
# Go to repo → Releases → Create a new release
# Tag: v0.1.0
# Attach: dist/rumbod_cli-0.1.0-py3-none-any.whl
# Attach: dist/files/rum-install.sh
```

## One-Liner Commands (after GitHub upload)

| Method | Command |
|--------|---------|
| curl | `bash -c "$(curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/rumbod-cli/main/install.sh)"` |
| wget | `bash -c "$(wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/rumbod-cli/main/install.sh)"` |
| pip | `pip install rumbod-cli --break-system-packages` |
| uv | `uv tool install rumbod-cli` |
| base64 | Download `dist/files/rum-install.sh`, run `bash rum-install.sh` |
