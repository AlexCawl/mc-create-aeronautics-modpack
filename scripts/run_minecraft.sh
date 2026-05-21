#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
ENV_FILE="$ROOT_DIR/.env"
REINSTALL_MODS=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --reinstall-mods)
      REINSTALL_MODS=true
      ;;
    -h|--help)
      printf '%s\n' "Usage: scripts/run_minecraft.sh [--reinstall-mods]"
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      printf '%s\n' "Usage: scripts/run_minecraft.sh [--reinstall-mods]" >&2
      exit 1
      ;;
  esac
  shift
done

if [ ! -f "$ENV_FILE" ]; then
  printf '%s\n' "Missing .env. Create it first:" >&2
  printf '%s\n' "  cp .env.defaults .env" >&2
  printf '%s\n' "  edit .env and fill the required values" >&2
  exit 1
fi

cd "$ROOT_DIR"

MC_UID="$(id -u)"
MC_GID="$(id -g)"
export MC_UID MC_GID

docker compose down

if [ "$REINSTALL_MODS" = true ]; then
  if [ -d "$ROOT_DIR/data/mods" ]; then
    find "$ROOT_DIR/data/mods" -maxdepth 1 -type f -name '*.jar' -delete
  fi
fi

docker compose up -d
