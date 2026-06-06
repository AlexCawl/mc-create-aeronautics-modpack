# Modpack Maintenance

`modpack/` owns the packwiz metadata. Commit `pack.toml`, `index.toml`, and `mods/*.pw.toml`; do not commit downloaded `.jar` files.

Server image baseline configs live under `server-config/config/` and are copied to `/config/` in the Docker image. They are applied by the itzg image during startup and are not indexed by packwiz.

## Build

```sh
scripts/build-mrpack.sh
```

The client artifact is written to `dist/mc-create-aeronautics-client.mrpack`.

To build raw mod jar zips locally:

```sh
scripts/build-mod-zips.sh
```

The client and server artifacts are written to `dist/client-mods.zip` and `dist/server-mods.zip`. The script uses `packwiz-installer-bootstrap` with `-s client` and `-s server`, so side filtering matches packwiz installation behavior. Mods marked `both` are included in both archives. The script uses committed packwiz metadata as-is; run `packwiz refresh` during maintenance when metadata changes, not during release packaging.

To build the CurseForge-compatible export locally:

```sh
cd modpack
packwiz curseforge export -o ../dist/mc-create-aeronautics-client-curseforge.zip
```

The CurseForge zip is an export artifact; publishing it on CurseForge may require checking non-CurseForge mod approvals and licenses.

## Add Or Update Mods

Run packwiz from `modpack/`:

```sh
cd modpack
packwiz modrinth add <mod-slug>
packwiz refresh
```

For CurseForge-only mods:

```sh
cd modpack
packwiz curseforge add <project-slug-or-id>
packwiz refresh
```

When mod metadata changes, update [Pinned mods](mods.md) in the same commit.

## Sides

- `both`: installed on client and dedicated server.
- `client`: installed only in the client pack.
- `server`: installed only on the dedicated server.

Use the narrowest side that works. Mark a mod `both` only when that exact version supports dedicated server loading or has been manually verified.

AutoModpack stays pinned in the pack for server-visible client sync.

## Release

Run the `Release` GitHub Actions workflow manually. It creates the next immutable `vN` GitHub Release, uploads the client pack artifacts and raw mod jar zips, marks the release as GitHub Latest, and publishes the matching server image with `vN` and `latest` Docker tags:

- `mc-create-aeronautics-client.mrpack`
- `mc-create-aeronautics-client-curseforge.zip`
- `client-mods.zip`
- `server-mods.zip`

Stable latest-download links:

- [Modrinth MrPack](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client.mrpack)
- [CurseForge export](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client-curseforge.zip)
- [Client mod jars](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/client-mods.zip)
- [Server mod jars](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/server-mods.zip)

Server image tags:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:v1
ghcr.io/alexcawl/mc-create-aeronautics-server:latest
```
