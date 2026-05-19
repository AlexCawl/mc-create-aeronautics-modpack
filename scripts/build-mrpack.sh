#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

# Use packwiz from PATH by default. PACKWIZ_BIN can point to a custom binary.
PACKWIZ_BIN="${PACKWIZ_BIN:-packwiz}"

# Fall back to Go's default install location when it is not on PATH yet.
if ! command -v "$PACKWIZ_BIN" >/dev/null 2>&1 && [ -x "$HOME/go/bin/packwiz" ]; then
  PACKWIZ_BIN="$HOME/go/bin/packwiz"
fi

# Write to dist/ by default, but allow an explicit output path as $1.
OUTPUT="${1:-$ROOT_DIR/dist/mc-create-aeronautics.mrpack}"

# Make sure output and cache directories exist before packwiz writes files.
mkdir -p "$(dirname "$OUTPUT")"
mkdir -p "$ROOT_DIR/.cache/packwiz"
cd "$ROOT_DIR/modpack"

# Refresh packwiz hashes, then export the Modrinth .mrpack artifact.
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" refresh
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" modrinth export -o "$OUTPUT"

printf 'Built %s\n' "$OUTPUT"
