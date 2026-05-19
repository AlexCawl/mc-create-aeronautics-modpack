# MC Create Aeronautics

Git-first infrastructure for a NeoForge 1.21.1 modded Minecraft server.

The repository owns reproducible configuration and pack metadata. Runtime state lives in `data/` on the VPS and is not committed.

## Layout

```text
compose.yaml
modpack/
  pack.toml
  index.toml
  mods/*.pw.toml
scripts/
docs/
data/      # runtime only, ignored by Git
```

## Runtime Model

- `modpack/` is the canonical packwiz source of truth.
- GitHub Actions builds `dist/mc-create-aeronautics.mrpack` on every push to `master`.
- The rolling GitHub Release tag is `master-latest`.
- The Docker server installs the published `.mrpack` through `itzg/minecraft-server`.
- Players import the same `.mrpack` into Prism Launcher for first setup.
- AutoModpack is included in the pack and handles later sync from server-visible files.

## Server Configuration

Create a local `.env` on the VPS. This file is intentionally ignored and no `.env.example` is committed.

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/master-latest/mc-create-aeronautics.mrpack
RCON_PASSWORD=change-me
MC_MEMORY=6G
MC_PORT=25565
MC_MOTD=Create Aeronautics
TZ=Asia/Yekaterinburg
```

Start the server:

```sh
docker compose up -d
```

Stop it:

```sh
docker compose down
```

Follow logs:

```sh
docker compose logs -f minecraft
```

## Building Locally

Install Go first. On macOS, the simplest option is Homebrew:

```sh
brew install go
go version
```

If you do not use Homebrew, install the official macOS package from `go.dev/dl/`, then verify:

```sh
go version
```

Install packwiz:

```sh
go install github.com/packwiz/packwiz@latest
```

If `packwiz` is not found after installation, add Go's default binary directory to your shell profile:

```sh
export PATH="$HOME/go/bin:$PATH"
```

Build the Modrinth pack:

```sh
scripts/build-mrpack.sh
```

The artifact is written to `dist/mc-create-aeronautics.mrpack`.

## Adding Mods

Run packwiz commands from `modpack/`:

```sh
cd modpack
packwiz modrinth add <mod-slug>
packwiz refresh
```

Set side metadata deliberately in each `mods/*.pw.toml`:

```toml
side = "both"
side = "client"
side = "server"
```

Use `both` only when the mod is safe on a dedicated server. AutoModpack and JEI are pinned as the initial baseline.

## Runtime Data

`data/` is mounted as `/data` in the container and contains world data, logs, crash reports, downloaded jars, generated configs, and AutoModpack runtime state. Do not commit it.

Server-only tracked config overlays are intentionally omitted for v1. Add `server-files/` later only when there is a concrete server-only file that must be reproduced from Git.
