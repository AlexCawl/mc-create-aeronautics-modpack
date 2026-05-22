# Modpack Maintenance

`modpack/` owns the packwiz metadata. Commit `pack.toml`, `index.toml`, and `mods/*.pw.toml`; do not commit downloaded `.jar` files.

## Build

```sh
scripts/build-mrpack.sh
```

The client artifact is written to `dist/mc-create-aeronautics-client.mrpack`.

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

Run the `Release` GitHub Actions workflow manually. It creates the next `vN` GitHub Release, uploads `mc-create-aeronautics-client.mrpack`, and publishes the matching server image with the same tag:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:v1
```
