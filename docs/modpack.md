# Modpack Maintenance

`modpack/` is the only mod metadata source. Commit `pack.toml`, `index.toml`, and `mods/*.pw.toml`; never commit downloaded `.jar` files.

## Sides

- `both`: installed on client and dedicated server.
- `client`: installed only for client modpacks.
- `server`: installed only for dedicated server installs.

Prefer the narrowest side that works. A mod may be marked `both` only when its project/version explicitly supports dedicated server loading or manual testing has proven it safe.

## AutoModpack Policy

AutoModpack is included as `both`. In v1 there is no custom `automodpack/host-modpack/main` staging and no client-only deduplication step.

The server publishes server-visible files through AutoModpack. Client-only QoL additions can be introduced later through either:

- a new `.mrpack` release that players import/update, or
- a future generated AutoModpack overlay.

## Release Artifact

The GitHub workflow publishes `mc-create-aeronautics.mrpack` to the rolling `master-latest` release.

Use this URL shape in VPS `.env`:

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/master-latest/mc-create-aeronautics.mrpack
```
