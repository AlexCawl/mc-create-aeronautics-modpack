#!/usr/bin/env sh
set -eu

# Resolve the repository root so the script works from any current directory.
ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

# Keep locally installed helper binaries out of Git.
BIN_DIR="$ROOT_DIR/.cache/bin"
mkdir -p "$BIN_DIR"

# packwiz CLI is installed from source with Go into the repo-local cache.
if ! command -v go >/dev/null 2>&1; then
  printf 'Go is required to install packwiz with this helper.\n' >&2
  printf 'Install Go, or install packwiz manually and put it on PATH.\n' >&2
  exit 1
fi

GOBIN="$BIN_DIR" go install github.com/packwiz/packwiz@latest

printf 'Installed %s/packwiz\n' "$BIN_DIR"
