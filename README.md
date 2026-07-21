# Math Primers

A small, self-hosted library of primers on math problems and conjectures. Each
primer is Markdown with LaTeX math and (optionally) fenced Lean code; the build
turns them into HTML pages (styling inlined; math rendered by MathJax from a CDN)
plus a homepage index, published via GitHub Pages.

## Layout

```
primers/*.md        the primers (Markdown + LaTeX math); TEMPLATE.md is the skeleton
scripts/primer.sh   build script -> HTML pages + index into build/
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

### Live preview (auto-rebuild on save)

```bash
scripts/watch.sh           # watches sources, rebuilds on save, live-reloads the browser
```

Leave it running while you write: it watches `primers/`, `glossary.md`, and `scripts/`,
rebuilds incrementally on every save, and (via `npx live-server`) refreshes your open
tab automatically at <http://localhost:8080>. Ctrl-C stops it. No manual rebuilds.

## Write a primer

Copy `primers/TEMPLATE.md`, give it frontmatter:

```yaml
---
title: "Some Conjecture"
status: "open"        # optional: open | disproved | proved  (shown as a badge)
---
```

Then write Markdown with `$inline$` / `$$display$$` math and ` ```lean ` blocks.

## Glossary (hover blurbs)

Short definitions that don't need a full page live in `glossary.md`, one per
`## Heading` (the heading's slug is the lookup key; the body may contain math):

```markdown
## Union-closed
A finite family $\mathcal{F}$ closed under unions: $A,B\in\mathcal F \Rightarrow A\cup B\in\mathcal F$.
```

Reference a term anywhere in a primer with a pandoc span; on hover/focus it shows
the definition as a popover (math included):

```markdown
Ordered by inclusion this forms a [union-closed]{.def} lattice.
[join-irreducible]{.def} elements are the building blocks.
[union-closed families]{.def key=union-closed}   <!-- when wording ≠ key -->
```

A pandoc Lua filter (`scripts/glossary.lua`) does the rewriting at build time;
unknown keys print a warning and fall back to plain text. When an entry outgrows a
blurb, promote it to its own primer page and link to it from `glossary.md`.

## Theorem environments

Author LaTeX-style environments as fenced divs with a recognized class and an
optional `title`; they render as accented, auto-numbered boxes:

```markdown
::: {.definition title="Union-closed family"}
A finite family $\mathcal{F}$ closed under unions.
:::

::: {.conjecture title="Frankl, 1979"}
Every finite union-closed family has an [abundant]{.def} element.
:::
```

Renders as **Definition 1 (Union-closed family).** … and **Conjecture 1 (Frankl,
1979).** … Recognized classes: `theorem`, `lemma`, `proposition`, `corollary`,
`definition`, `example`, `remark`, `conjecture`, `claim` (each with its own accent
color). Add `.unnumbered` to drop the number. Glossary terms and math work inside.
Filter: `scripts/theorems.lua`.

## Publish

Pushing to `main` triggers `.github/workflows/pages.yml`, which builds the site
and deploys it to GitHub Pages. Enable it once under **Settings → Pages → Source:
GitHub Actions**.
