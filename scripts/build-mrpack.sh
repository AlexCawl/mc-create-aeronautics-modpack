#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

# Allow a repo-local packwiz binary, for example:
# PACKWIZ_BIN=.cache/bin/packwiz scripts/build-mrpack.sh
PACKWIZ_BIN="${PACKWIZ_BIN:-packwiz}"

# Resolve repo-relative binary paths before changing directories.
case "$PACKWIZ_BIN" in
  /*) ;;
  */*) PACKWIZ_BIN="$ROOT_DIR/$PACKWIZ_BIN" ;;
esac

# Write to dist/ by default, but allow an explicit output path as $1.
OUTPUT="${1:-$ROOT_DIR/dist/mc-create-aeronautics.mrpack}"

# Make sure the output directory exists before packwiz writes the artifact.
mkdir -p "$(dirname "$OUTPUT")"
mkdir -p "$ROOT_DIR/.cache/packwiz"
cd "$ROOT_DIR/modpack"

# Refresh packwiz hashes, then export the Modrinth .mrpack artifact.
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" refresh
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" modrinth export -o "$OUTPUT"

printf 'Built %s\n' "$OUTPUT"
