# Modpack Maintenance

`modpack/` is the only mod metadata source. Commit `pack.toml`, `index.toml`, and `mods/*.pw.toml`; never commit downloaded `.jar` files.

## Local Build

Build the Modrinth pack from the repository root:

```sh
scripts/build-mrpack.sh
```

The artifact is written to `dist/mc-create-aeronautics.mrpack`.

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

The GitHub workflow publishes `mc-create-aeronautics.mrpack` to the rolling `master-latest` release on every push to `master`.

`master-latest` is intentionally named after the source branch. It is separate from GitHub's own "Latest release" concept and makes it clear that the artifact is mutable.

Manual workflow runs can create immutable SemVer-style releases with a `v` prefix, such as `v0.1.0`. Existing manual release tags are not overwritten.

Use this URL shape in VPS `.env`:

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/master-latest/mc-create-aeronautics.mrpack
```

Use this URL shape to pin the VPS to an immutable release:

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/v0.1.0/mc-create-aeronautics.mrpack
```
