#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

CLIENT_OUTPUT="${1:-$ROOT_DIR/dist/client-mods.zip}"
SERVER_OUTPUT="${2:-$ROOT_DIR/dist/server-mods.zip}"

# Resolve repo-relative output paths before changing directories.
case "$CLIENT_OUTPUT" in
  /*) ;;
  *) CLIENT_OUTPUT="$ROOT_DIR/$CLIENT_OUTPUT" ;;
esac

case "$SERVER_OUTPUT" in
  /*) ;;
  *) SERVER_OUTPUT="$ROOT_DIR/$SERVER_OUTPUT" ;;
esac

command -v java >/dev/null 2>&1 || {
  printf '%s\n' 'java is required to run packwiz-installer-bootstrap.' >&2
  exit 1
}

command -v zip >/dev/null 2>&1 || {
  printf '%s\n' 'zip is required to build mod jar archives.' >&2
  exit 1
}

CACHE_DIR="$ROOT_DIR/.cache/packwiz-installer"
BOOTSTRAP_JAR="$CACHE_DIR/packwiz-installer-bootstrap.jar"
BOOTSTRAP_URL="${PACKWIZ_INSTALLER_BOOTSTRAP_URL:-https://github.com/packwiz/packwiz-installer-bootstrap/releases/download/v0.0.3/packwiz-installer-bootstrap.jar}"
PACK_FILE="$ROOT_DIR/modpack/pack.toml"

mkdir -p "$CACHE_DIR" "$(dirname "$CLIENT_OUTPUT")" "$(dirname "$SERVER_OUTPUT")"

if [ ! -f "$BOOTSTRAP_JAR" ]; then
  command -v curl >/dev/null 2>&1 || {
    printf '%s\n' 'curl is required to download packwiz-installer-bootstrap.' >&2
    exit 1
  }

  curl -fsSL "$BOOTSTRAP_URL" -o "$BOOTSTRAP_JAR"
fi

build_side() {
  side="$1"
  output="$2"
  work_dir="$CACHE_DIR/$side"
  mods_dir="$work_dir/mods"

  rm -rf "$work_dir"
  mkdir -p "$mods_dir"

  (
    cd "$work_dir"
    java -jar "$BOOTSTRAP_JAR" -g -s "$side" "$PACK_FILE"
  )

  rm -f "$output"

  # Create a flat zip with only mod jars; modconfig downloaded by packwiz stay out.
  (
    cd "$mods_dir"
    jar_count=$(find . -maxdepth 1 -type f -name '*.jar' | wc -l | tr -d ' ')
    if [ "$jar_count" -eq 0 ]; then
      printf 'No jar files were downloaded for %s side.\n' "$side" >&2
      exit 1
    fi

    find . -maxdepth 1 -type f -name '*.jar' -exec zip -q -X -j "$output" {} +
    printf 'Built %s (%s mods)\n' "$output" "$jar_count"
  )
}

build_side client "$CLIENT_OUTPUT"
build_side server "$SERVER_OUTPUT"
