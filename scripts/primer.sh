#!/usr/bin/env bash
# primer.sh — render Markdown+LaTeX primers to a small self-contained local site.
#
# Usage:
#   scripts/primer.sh                 # incremental: rebuild only changed primers + index
#   scripts/primer.sh --force         # rebuild every primer regardless of mtime
#   scripts/primer.sh --open          # incremental build, then open the site index
#   scripts/primer.sh --serve         # incremental build, then serve on localhost:8000
#   scripts/primer.sh primers/foo.md  # (re)build just that primer, then refresh index
#
# Each primer -> a single self-contained HTML file (CSS + MathJax + syntax
# highlighting inlined; works offline). build/index.html links them all.
#
# "Changed" = the source .md, or a shared asset (primer.css / lean.xml), is newer
# than the built .html. Shared-asset changes force a full rebuild, since they
# affect every page.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CSS="$HERE/scripts/primer.css"
XML="$HERE/scripts/lean.xml"
GLOSS="$HERE/glossary.md"
LUA="$HERE/scripts/glossary.lua"
THM="$HERE/scripts/theorems.lua"
HEAD="$HERE/scripts/theme-head.html"
TOGGLE="$HERE/scripts/theme-toggle.html"
SRCDIR="$HERE/primers"
OUTDIR="$HERE/build"
mkdir -p "$OUTDIR"

# Inline the stylesheet into each page's <head> as a <style> block (styling stays
# self-contained), while MathJax loads from its CDN. We do NOT inline MathJax:
# inlining breaks its font loading (the font path resolves relative to a base URL
# that doesn't exist when inlined), which renders math with fallback fonts.
STYLE_HEADER="$(mktemp)"
{ printf '<style>\n'; cat "$CSS"; printf '\n</style>\n'; } > "$STYLE_HEADER"
trap 'rm -f "$STYLE_HEADER"' EXIT

# --- helpers ---------------------------------------------------------------

# Read a YAML frontmatter field (strips quotes). Usage: frontmatter FILE KEY
frontmatter() {
  awk -v key="$2" '
    NR==1 && $0=="---" {inyaml=1; next}
    inyaml && $0=="---" {exit}
    inyaml && $0 ~ "^"key":" {
      sub("^"key":[ \t]*", ""); gsub(/^"|"$/, ""); print; exit
    }
  ' "$1" 2>/dev/null || true
}

# Best title for a primer: frontmatter title, else first heading, else filename.
title_of() {
  local t
  t="$(frontmatter "$1" title)"
  if [[ -z "$t" ]]; then
    t="$(grep -m1 '^#\+ ' "$1" 2>/dev/null | sed 's/^#\+[ ]*//' || true)"
  fi
  [[ -z "$t" ]] && t="$(basename "${1%.md}")"
  printf '%s' "$t"
}

render_one() {
  local src="$1" base out
  base="$(basename "${src%.md}")"
  out="$OUTDIR/$base.html"
  local title_args=()
  if ! grep -qE '^title:' "$src"; then
    title_args=(--metadata "title=$base")
  fi
  GLOSSARY_FILE="$GLOSS" pandoc "$src" \
    --standalone \
    --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js \
    --toc --toc-depth=2 \
    --syntax-definition "$XML" \
    --lua-filter "$THM" \
    --lua-filter "$LUA" \
    --include-in-header "$STYLE_HEADER" \
    --include-in-header "$HEAD" \
    --include-before-body "$HERE/scripts/nav.html" \
    --include-after-body "$TOGGLE" \
    ${title_args[@]+"${title_args[@]}"} \
    -o "$out"
}

# Does OUT need rebuilding from SRC? (missing, or src/shared-asset newer)
needs_build() {
  local src="$1" out="$2"
  [[ ! -f "$out" ]] && return 0
  [[ "$src" -nt "$out" ]] && return 0
  [[ "$CSS" -nt "$out" ]] && return 0
  [[ "$XML" -nt "$out" ]] && return 0
  [[ "$GLOSS" -nt "$out" ]] && return 0
  [[ "$LUA" -nt "$out" ]] && return 0
  [[ "$THM" -nt "$out" ]] && return 0
  [[ "$HEAD" -nt "$out" ]] && return 0
  [[ "$TOGGLE" -nt "$out" ]] && return 0
  return 1
}

# List primer sources (excludes TEMPLATE.md). Prints one path per line.
primer_sources() {
  local f
  for f in "$SRCDIR"/*.md; do
    [[ -e "$f" ]] || continue
    [[ "$(basename "$f")" == "TEMPLATE.md" ]] && continue
    printf '%s\n' "$f"
  done
}

# Regenerate build/index.html — the site homepage listing all primers.
build_index() {
  local idx_md f base title status
  idx_md="$(mktemp)"
  {
    echo '---'
    echo 'title: "Math Primers"'
    echo '---'
    echo
    echo 'A personal library for learning about different areas of mathematics. Each'
    echo 'primer orients you on a problem or conjecture — the statement, background,'
    echo 'notation, and how a counterexample would be certified in the disproof harness.'
    echo
    if [[ -z "$(primer_sources)" ]]; then
      echo '_No primers yet — start one from `primers/TEMPLATE.md`._'
    else
      while IFS= read -r f; do
        base="$(basename "${f%.md}")"
        title="$(title_of "$f")"
        status="$(frontmatter "$f" status)"
        printf -- '- [%s](%s.html)' "$title" "$base"
        if [[ -n "$status" ]]; then
          case "$status" in
            open)              label="open problem" ;;
            disproved)         label="disproved" ;;
            proved|confirmed)  label="proved" ;;
            *)                 label="$status" ;;
          esac
          printf ' <span class="badge badge-%s">%s</span>' "$status" "$label"
        fi
        echo
      done < <(primer_sources)
    fi
  } > "$idx_md"
  pandoc "$idx_md" --from markdown --standalone \
    --mathjax=https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js \
    --include-in-header "$STYLE_HEADER" \
    --include-in-header "$HEAD" \
    --include-after-body "$TOGGLE" \
    -o "$OUTDIR/index.html"
  rm -f "$idx_md"
}

# --- argument handling -----------------------------------------------------

FORCE=0; OPEN=0; SERVE=0; ONE=""
for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    --open)  OPEN=1 ;;
    --serve) SERVE=1 ;;
    --all)   : ;;                 # accepted for back-compat; default is already all
    -*)      echo "primer: unknown option: $arg" >&2; exit 2 ;;
    *)       ONE="$arg" ;;
  esac
done

if [[ -n "$ONE" ]]; then
  [[ -f "$ONE" ]] || { echo "primer: no such file: $ONE" >&2; exit 1; }
  render_one "$ONE"
  echo "built:   $(basename "${ONE%.md}").html"
  build_index
  echo "index:   index.html"
else
  built=0; skipped=0
  while IFS= read -r f; do
    base="$(basename "${f%.md}")"
    out="$OUTDIR/$base.html"
    if [[ "$FORCE" == 1 ]] || needs_build "$f" "$out"; then
      render_one "$f"; echo "built:   $base.html"; built=$((built + 1))
    else
      echo "skipped: $base.html (up to date)"; skipped=$((skipped + 1))
    fi
  done < <(primer_sources)
  build_index
  echo "index:   index.html"
  echo "-- $built rebuilt, $skipped unchanged --"
fi

[[ "$OPEN" == 1 ]] && open "$OUTDIR/index.html"
if [[ "$SERVE" == 1 ]]; then
  echo "serving $OUTDIR at http://localhost:8000  (Ctrl-C to stop)"
  ( cd "$OUTDIR" && python3 -m http.server 8000 )
fi
