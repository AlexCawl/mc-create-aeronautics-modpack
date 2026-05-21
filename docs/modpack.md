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

The GitHub workflow publishes `mc-create-aeronautics-client.mrpack` to the rolling `master-latest` release and publishes a matching `ghcr.io/alexcawl/mc-create-aeronautics-server:master-latest` Docker image on every push to `master`.

`master-latest` is intentionally named after the source branch. It is separate from GitHub's own "Latest release" concept and makes it clear that the artifact is mutable.

Manual workflow runs create immutable incremental releases with a `v` prefix and a monotonically increasing number, such as `v1`, `v2`, and `v3`. Existing manual release tags are not overwritten. The server image is pushed with the same tag as the GitHub Release.

Use this image shape in VPS Compose for the rolling server:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:master-latest
```

Use this image shape to pin the VPS to an immutable release:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:v1
```
