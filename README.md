# Math Primers

A small, self-hosted library of primers on math problems and conjectures. Each
primer is Markdown with LaTeX math and (optionally) fenced Lean code; the build
turns them into self-contained HTML pages plus a homepage index, published via
GitHub Pages.

## Layout

```
primers/*.md        the primers (Markdown + LaTeX math); TEMPLATE.md is the skeleton
scripts/primer.sh   build script -> self-contained HTML + index into build/
scripts/primer.css  page styling (light/dark, syntax + math)
scripts/lean.xml    Lean syntax definition for code highlighting
scripts/nav.html    the "← All primers" home link injected atop each primer
build/              generated site (git-ignored; built locally or by CI)
```

## Build locally

Requires [pandoc](https://pandoc.org) (3.1.1+).

```bash
scripts/primer.sh          # incremental: rebuild only changed primers + index
scripts/primer.sh --open   # ...and open the homepage
scripts/primer.sh --serve  # ...and serve at http://localhost:8000
scripts/primer.sh --force  # rebuild everything
```

## Write a primer

Copy `primers/TEMPLATE.md`, give it frontmatter:

```yaml
---
title: "Some Conjecture"
status: "open"        # optional: open | disproved | proved  (shown as a badge)
---
```

Then write Markdown with `$inline$` / `$$display$$` math and ` ```lean ` blocks.

## Publish

Pushing to `main` triggers `.github/workflows/pages.yml`, which builds the site
and deploys it to GitHub Pages. Enable it once under **Settings → Pages → Source:
GitHub Actions**.
