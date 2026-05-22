# Repository Architecture

This repository keeps reproducible modpack inputs and build pipelines in Git. Deployment configuration lives in a separate repository.

## Stack

- `ghcr.io/alexcawl/mc-create-aeronautics-server` extends `itzg/minecraft-server:java21` with pinned packwiz metadata.
- NeoForge 1.21.1 is the mod loader.
- packwiz owns pinned mod metadata.
- GitHub Actions exports the packwiz pack as a Modrinth `.mrpack` for clients and publishes a matching server Docker image.
- The server image bakes in NeoForge 1.21.1, the packwiz URL, old-mod cleanup defaults, and the default MOTD.
- AutoModpack is included in the pack for later client sync from server-visible files.
- `spark` stays in the modpack as an on-demand Minecraft diagnostics tool.

## Layout

```text
README.md
docs/
  arch.md
  modpack.md
  onboarding.md
scripts/
  build-mrpack.sh
docker/
  minecraft/Dockerfile
modpack/
  pack.toml
  index.toml
  mods/*.pw.toml
```

## State Boundaries

Tracked in Git:

- packwiz pack metadata.
- helper scripts.
- documentation.
- GitHub Actions release workflow.
- server image Dockerfile.

Not tracked in Git:

- `data/`
- downloaded `.jar` files.
- generated `.mrpack` files.
- `dist/`
- `.cache/`
- `site/`

## Runtime Model

The server image is bootstrapped from this repository's `modpack/` metadata. The image contains `modpack/` at `/packwiz`, and itzg runs packwiz installer in server mode from `/packwiz/pack.toml`.

Players import the `.mrpack` from the matching GitHub Release into Prism Launcher for first setup.

## Release Model

Manual workflow runs create GitHub Releases and matching server image tags such as `v1`, `v2`, and `v3`.

Use `vN` tags to pin a server to a specific release.
