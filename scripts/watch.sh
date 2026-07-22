#!/usr/bin/env bash
# watch.sh — auto-rebuild the primers site on save, with live browser reload.
#
#   scripts/watch.sh
#
# Watches primers/, glossary.md, and scripts/ (CSS, lean.xml, Lua filters). On any
# change it reruns the incremental build. If node/npx is available it also serves
# build/ with live reload, so your open browser tab refreshes itself on save.
#
# Leave it running while you author; Ctrl-C stops it (and the server).
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$HERE"
export PATH="/opt/homebrew/bin:$PATH"
export PRIMER_DEV=1   # local preview shows block/line numbers; CI builds never set this

PORT="${PORT:-8080}"
MARKER="$(mktemp)"
SERVER_PID=""
cleanup() {
  rm -f "$MARKER"
  if [ -n "${SERVER_PID:-}" ]; then
    pkill -P "$SERVER_PID" 2>/dev/null   # the node/live-server child that npx spawned
    kill "$SERVER_PID" 2>/dev/null       # npx itself
  fi
}
# Clean up on normal exit; on Ctrl-C/kill, clean up AND actually exit (a plain INT
# trap would run cleanup but then resume the while-loop, so the script never stopped).
trap cleanup EXIT
trap 'trap - EXIT; cleanup; exit 130' INT TERM

# Initial build.
scripts/primer.sh --force || true

# Optional live-reload server (needs node/npx). It watches build/ and refreshes the
# browser whenever the build writes new HTML. Ctrl-C (same process group) stops it too.
if command -v npx >/dev/null 2>&1; then
  npx --yes live-server build --port="$PORT" --quiet >/dev/null 2>&1 &
  SERVER_PID=$!
  echo "live-reload → http://localhost:$PORT  (auto-refreshes on save)"
else
  echo "node/npx not found — I'll rebuild on save; refresh the browser yourself"
  echo "  (or serve build/ with: scripts/primer.sh --serve)"
fi

echo "watching primers/, glossary.md, scripts/ … edit & save to rebuild.  Ctrl-C to stop."

# Poll for changes: rebuild whenever a watched source is newer than the last build.
touch "$MARKER"
while true; do
  if [ -n "$(find primers glossary.md scripts -type f -newer "$MARKER" 2>/dev/null)" ]; then
    touch "$MARKER"
    if scripts/primer.sh; then
      echo "  ✓ rebuilt $(date +%H:%M:%S)"
    else
      echo "  ⚠ build failed — fix and save to retry"
    fi
  fi
  sleep 1
done
