# Modpack Maintenance

`modpack/` is the only mod metadata source. Commit `pack.toml`, `index.toml`, and `mods/*.pw.toml`; never commit downloaded `.jar` files.

The current mod list is tracked in [Mods](mods.md). Update that table in the same commit as any mod metadata change.

## Local Build

Build the Modrinth pack from the repository root:

```sh
scripts/build-mrpack.sh
```

The artifact is written to `dist/mc-create-aeronautics-client.mrpack`.

To choose another output path:

```sh
scripts/build-mrpack.sh dist/custom-name.mrpack
```

`dist/` is ignored by Git.

## Adding Mods

Run packwiz commands from `modpack/`:

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

Prefer Modrinth metadata when the exact file is available there. CurseForge metadata is acceptable for mods that are not available on Modrinth.

## Sides

- `both`: installed on client and dedicated server.
- `client`: installed only for client modpacks.
- `server`: installed only for dedicated server installs.

Prefer the narrowest side that works. A mod may be marked `both` only when its project/version explicitly supports dedicated server loading or manual testing has proven it safe.

Set side metadata deliberately in each `mods/*.pw.toml`:

```toml
side = "both"
side = "client"
side = "server"
```

## AutoModpack Policy

AutoModpack is included as `both`. In v1 there is no custom `automodpack/host-modpack/main` staging and no client-only deduplication step.

The server publishes server-visible files through AutoModpack. Client-only QoL additions can be introduced later through either:

- a new `.mrpack` release that players import/update, or
- a future generated AutoModpack overlay.

## Release Artifact

The GitHub release workflow runs manually. Each run publishes `mc-create-aeronautics-client.mrpack` to a new GitHub Release and publishes a matching server image with the same tag.

Release tags use a `v` prefix and a monotonically increasing number, such as `v1`, `v2`, and `v3`. Existing release tags are not overwritten.

Use this image shape in deployment Compose:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:v1
```
