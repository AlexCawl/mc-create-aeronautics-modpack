# Repository Architecture

This repository keeps reproducible Minecraft server inputs in Git and keeps runtime state outside Git.

## Stack

- Docker Compose runs the server container.
- `itzg/minecraft-server:java21` provides the Minecraft server image.
- NeoForge 1.21.1 is the mod loader.
- packwiz owns pinned mod metadata.
- GitHub Actions exports the packwiz pack as a Modrinth `.mrpack`.
- `itzg/minecraft-server` installs the published `.mrpack` through its Modrinth modpack flow.
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

The server is bootstrapped from a GitHub Release `.mrpack` URL. Players import the same `.mrpack` into Prism Launcher for first setup.

Grafana is bound to `127.0.0.1` and is intended to be opened through an SSH tunnel.

## Release Model

Every push to `master` refreshes the mutable `master-latest` release. Manual workflow runs can create immutable releases with tags such as `v0.1.0`.

Use `master-latest` for a server that follows the branch. Use immutable release URLs for a pinned server.
