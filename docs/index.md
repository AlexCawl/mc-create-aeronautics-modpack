# MC Create Aeronautics

Git-first infrastructure for a NeoForge 1.21.1 modded Minecraft server.

The repository owns reproducible modpack metadata and build pipelines for the client `.mrpack` and server bootstrap image.

## Documentation

- [Repository Architecture](arch.md): repository structure, stack, and state boundaries.
- [Modpack Maintenance](modpack.md): packwiz workflow, mod sides, AutoModpack policy, and releases.
- [Mods](mods.md): current pinned mod list from packwiz metadata.
- [Repository Onboarding](onboarding.md): local dependencies required to work with the repository.

Deployment files live in a separate repository.

## Runtime Model

- `modpack/` is the canonical packwiz source of truth.
- Manual GitHub Actions releases build `mc-create-aeronautics-client.mrpack` and a matching server Docker image.
- Release tags use an auto-incremented `vN` shape such as `v1`, `v2`, and `v3`.
- The server image is `ghcr.io/alexcawl/mc-create-aeronautics-server`, which contains the pinned packwiz metadata.
- Players import the same `.mrpack` into Prism Launcher for first setup.
- AutoModpack is included for later client sync from server-visible files.
