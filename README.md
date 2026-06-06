# MC Create Aeronautics

Git-first source for the NeoForge 1.21.1 Create Aeronautics modpack and its server bootstrap image.

- `modpack/` is the canonical packwiz source.
- `server-config/` contains server image baseline configs copied to `/config`.
- Manual GitHub Actions releases build Modrinth `.mrpack` and CurseForge `.zip` client packs, plus a matching server image.
- Release tags use auto-incremented `vN` values such as `v1`, `v2`, and `v3`.
- The newest client pack is exposed through GitHub Latest release download links.
- The server image is published as `ghcr.io/alexcawl/mc-create-aeronautics-server:<tag>` and `ghcr.io/alexcawl/mc-create-aeronautics-server:latest`.
- Deployment files live in a separate repository.

Docs:

- [Modpack maintenance](docs/modpack.md)
- [Pinned mods](docs/mods.md)
