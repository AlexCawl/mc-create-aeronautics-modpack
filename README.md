# MC Create Aeronautics

Git-first infrastructure for a NeoForge 1.21.1 modded Minecraft server.

The repository owns reproducible configuration and pack metadata. Runtime state lives in `data/` on the VPS and is not committed.

## Documentation

- [Repository Architecture](docs/arch.md): repository structure, stack, and state boundaries.
- [Modpack Maintenance](docs/modpack.md): packwiz workflow, mod sides, AutoModpack policy, and releases.
- [VPS Operations](docs/vps.md): `.env`, Docker Compose commands, updates, and backups.
- [Monitoring](docs/monitoring.md): Grafana, Prometheus, cAdvisor, mc-monitor, and spark diagnostics.
- [Repository Onboarding](docs/onboarding.md): local dependencies required to work with the repository.

The same Markdown documentation is published to GitHub Pages with MkDocs when Pages is configured to use GitHub Actions.

## Short Version

- `modpack/` is the canonical packwiz source of truth.
- GitHub Actions builds `mc-create-aeronautics.mrpack` on every push to `master`.
- The rolling GitHub Release tag is `master-latest`.
- Manual GitHub Actions runs can create immutable SemVer-style releases such as `v0.1.0`.
- The VPS server runs from the published `.mrpack` through `itzg/minecraft-server`.
- Monitoring runs with `itzg/mc-monitor`, cAdvisor, Prometheus, and Grafana.
- Players import the same `.mrpack` into Prism Launcher for first setup.
- AutoModpack is included for later client sync from server-visible files.
- `data/` is runtime-only and ignored by Git.
