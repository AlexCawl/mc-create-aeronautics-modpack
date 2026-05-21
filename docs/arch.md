# Repository Architecture

This repository keeps reproducible Minecraft server inputs in Git and keeps runtime state outside Git.

## Stack

- Docker Compose runs the server container.
- `ghcr.io/alexcawl/mc-create-aeronautics-server` extends `itzg/minecraft-server:java21` with pinned packwiz metadata.
- NeoForge 1.21.1 is the mod loader.
- packwiz owns pinned mod metadata.
- GitHub Actions exports the packwiz pack as a Modrinth `.mrpack` for clients and publishes a matching server Docker image.
- The server image installs server-side mods through `PACKWIZ_URL=/packwiz/pack.toml`.
- AutoModpack is included in the pack for later client sync from server-visible files.
- `itzg/mc-monitor`, Prometheus Exporter, cAdvisor, Prometheus, and Grafana provide always-on monitoring.
- `itzg/rcon` provides a localhost-bound web console for Minecraft RCON commands.
- `spark` stays in the modpack as an on-demand Minecraft diagnostics tool.

## Layout

```text
compose.yaml
README.md
docs/
  arch.md
  modpack.md
  monitoring.md
  onboarding.md
  vps.md
monitoring/
  prometheus/prometheus.yml
  grafana/provisioning/
  grafana/dashboards/
scripts/
  build-mrpack.sh
docker/
  minecraft/Dockerfile
modpack/
  pack.toml
  index.toml
  mods/*.pw.toml
data/      # runtime only, ignored by Git
```

## State Boundaries

Tracked in Git:

- Docker Compose service definition.
- packwiz pack metadata.
- helper scripts.
- documentation.
- GitHub Actions release workflow.
- monitoring configuration.

Not tracked in Git:

- `.env`
- `data/`
- downloaded `.jar` files.
- generated `.mrpack` files.
- `dist/`
- `.cache/`
- `site/`

## Runtime Model

The VPS runs Docker Compose from a cloned repository checkout. The default stack starts Minecraft and monitoring together. The server container mounts `./data:/data`, so worlds, logs, crash reports, generated configs, downloaded jars, and AutoModpack runtime state stay on the VPS.

The server is bootstrapped from the published server Docker image. The image contains `modpack/` at `/packwiz`, and itzg runs packwiz installer in server mode from `/packwiz/pack.toml`. Players import the `.mrpack` from the matching GitHub Release into Prism Launcher for first setup.

Grafana is bound to `127.0.0.1` and is intended to be opened through an SSH tunnel.

## Release Model

Every push to `master` refreshes the mutable `master-latest` GitHub Release and server image tag. Manual workflow runs create immutable incremental releases and matching server image tags such as `v1`, `v2`, and `v3`.

Use `master-latest` for a server that follows the branch. Use immutable `vN` tags for a pinned server.
