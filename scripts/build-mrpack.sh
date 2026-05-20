#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

# Prefer PATH, but also support Go's default install location in fresh CI shells.
PACKWIZ_BIN="packwiz"
if ! command -v "$PACKWIZ_BIN" >/dev/null 2>&1; then
  PACKWIZ_BIN="$HOME/go/bin/packwiz"
fi

command -v "$PACKWIZ_BIN" >/dev/null 2>&1 || {
  printf '%s\n' 'packwiz is not available on PATH or at ~/go/bin/packwiz.' >&2
  printf '%s\n' 'For local setup, see docs/onboarding.md.' >&2
  exit 1
}

# Write to dist/ by default, but allow an explicit output path as $1.
OUTPUT="${1:-$ROOT_DIR/dist/mc-create-aeronautics.mrpack}"

# Resolve repo-relative output paths before changing directories.
case "$OUTPUT" in
  /*) ;;
  *) OUTPUT="$ROOT_DIR/$OUTPUT" ;;
esac

# Make sure output and cache directories exist before packwiz writes files.
mkdir -p "$(dirname "$OUTPUT")"
mkdir -p "$ROOT_DIR/.cache/packwiz"
cd "$ROOT_DIR/modpack"

# Refresh packwiz hashes, then export the Modrinth .mrpack artifact.
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" refresh
"$PACKWIZ_BIN" --cache "$ROOT_DIR/.cache/packwiz" modrinth export -o "$OUTPUT"

printf 'Built %s\n' "$OUTPUT"
