# MC Create Aeronautics

Git-first infrastructure for a NeoForge 1.21.1 modded Minecraft server.

The repository owns reproducible configuration and pack metadata. Runtime state lives in `data/` on the VPS and is not committed.

## Documentation

- [Repository Architecture](arch.md): repository structure, stack, and state boundaries.
- [Modpack Maintenance](modpack.md): packwiz workflow, mod sides, AutoModpack policy, and releases.
- [Mods](mods.md): current pinned mod list from packwiz metadata.
- [VPS Operations](vps.md): `.env`, Docker Compose commands, updates, and backups.
- [Monitoring](monitoring.md): Grafana, Prometheus, cAdvisor, mc-monitor, Prometheus Exporter, RCON Web Admin, and spark diagnostics.
- [Repository Onboarding](onboarding.md): local dependencies required to work with the repository.

## Runtime Model

- `modpack/` is the canonical packwiz source of truth.
- GitHub Actions builds `mc-create-aeronautics-client.mrpack` and a matching server Docker image on every push to `master`.
- The rolling GitHub Release tag is `master-latest`.
- Manual GitHub Actions runs create immutable incremental releases such as `v1`, `v2`, and `v3`.
- The VPS server runs from `ghcr.io/alexcawl/mc-create-aeronautics-server`, which contains the pinned packwiz metadata.
- Monitoring runs with `itzg/mc-monitor`, Prometheus Exporter, cAdvisor, Prometheus, and Grafana.
- RCON Web Admin is available over an SSH tunnel for server commands.
- Players import the same `.mrpack` into Prism Launcher for first setup.
- AutoModpack is included for later client sync from server-visible files.
- `data/` is runtime-only and ignored by Git.
