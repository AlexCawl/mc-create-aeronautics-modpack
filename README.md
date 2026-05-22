# MC Create Aeronautics

Git-first source for the NeoForge 1.21.1 Create Aeronautics modpack and its server bootstrap image.

- `modpack/` is the canonical packwiz source.
- Manual GitHub Actions releases build `mc-create-aeronautics-client.mrpack` and a matching server image.
- Release tags use auto-incremented `vN` values such as `v1`, `v2`, and `v3`.
- The server image is `ghcr.io/alexcawl/mc-create-aeronautics-server:<tag>`.
- Deployment files live in a separate repository.

Docs:

- [Modpack maintenance](docs/modpack.md)
- [Pinned mods](docs/mods.md)
