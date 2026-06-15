# Repository Instructions

Перед выполнением запроса пользователя всегда сначала перечитай этот файл, если он есть в корне репозитория.

## Project Principles

- Keep the repository Git-first: reproducible mod metadata and build configuration live in Git, runtime state does not.
- Treat `modpack/` as the canonical source of truth for the packwiz modpack.
- Treat `modconfig/` as the committed baseline server config copied into `/config/` by the server image.
- Do not commit downloaded `.jar` files, generated `.mrpack`/CurseForge `.zip` files, `dist/`, `site/`, or `.cache/`.
- Keep v1 simple: no AutoModpack client-only overlay or deduplication unless explicitly requested.

## Repository Layout

- `modpack/pack.toml`, `modpack/index.toml`, and `modpack/mods/*.pw.toml` are the reproducible packwiz source.
- `modconfig/` contains server baseline config copied by `docker/minecraft/Dockerfile`; it is not indexed by packwiz.
- `docker/minecraft/Dockerfile` builds the server bootstrap image from `itzg/minecraft-server:java21`.
- `docs/` contains the MkDocs source; generated `site/` output is ignored.
- `.github/workflows/release.yml` orchestrates manual `vN` releases, client exports, and GHCR server image publishing.

## Shell Scripts

- Prefer KISS shell scripts: POSIX `sh`, short linear flow, no clever abstractions unless they remove real complexity.
- Comment meaningful blocks of logic, not every command.
- Fail early with `set -eu`.
- Keep generated artifacts and tool caches under ignored directories such as `dist/` or `.cache/`.
- Repository scripts should work both locally and on CI: use `packwiz` from `PATH` first, then `$HOME/go/bin/packwiz` as the Go default install location.

## Git Workflow

- Check `git status --short --branch` before committing.
- Do not rewrite history, reset, amend, rebase, or force-push unless the user explicitly asks.
- Do not revert user changes unless the user explicitly asks.
- Keep commits focused and use Conventional Commits:
  - `feat: ...` for new capabilities or repo structure.
  - `fix: ...` for bug fixes.
  - `docs: ...` for documentation-only changes.
  - `chore: ...` for maintenance, tooling, and housekeeping.
- Before committing, run lightweight validation that matches the change, such as shell syntax checks, `docker compose config`, `packwiz refresh`, or `.mrpack` export when available.

## Build and Release Workflow

- Client artifacts are generated, not source. Build local exports from `modpack/` into ignored `dist/`.
- Build the Modrinth pack with `packwiz modrinth export -o ../dist/mc-create-aeronautics-client.mrpack`.
- Build the CurseForge export with `packwiz curseforge export -o ../dist/mc-create-aeronautics-client-curseforge.zip`.
- Keep release tags immutable and auto-incremented as `vN`; do not retag or overwrite releases unless explicitly requested.
- Keep the server image name aligned with the deployment repository: `ghcr.io/alexcawl/mc-create-aeronautics-server:<tag>` and `latest`.
- If the server image build context changes, check `.dockerignore` so secrets, runtime data, generated docs, caches, and artifacts stay out of the image context.

## Minecraft Pack Rules

- Use `side = "client"`, `side = "server"`, or `side = "both"` deliberately in each `mods/*.pw.toml`.
- Mark a mod as `both` only when the exact version supports dedicated server loading or has been manually verified.
- Keep AutoModpack pinned in `modpack/` while the repository uses AutoModpack for post-bootstrap client sync.
- When adding, removing, updating, or changing the side of a mod, update `docs/mods.md` in the same commit.
- Run `packwiz refresh` from `modpack/` after changing packwiz metadata so `index.toml` and `pack.toml` hashes remain consistent.
- Prefer Modrinth metadata when available; use CurseForge metadata only for mods that are unavailable or better maintained there.
- Do not add raw downloaded jars to Git. If a direct-download/GitHub-only mod is unavoidable, document the source and side explicitly in `docs/mods.md`.
- Preserve NeoForge `1.21.1` compatibility unless the user explicitly asks for a Minecraft/loader upgrade.

## Server Config Rules

- Keep deploy-time secrets out of Git. Use `${CFG_*}` placeholders in `modconfig/` and document the corresponding env vars in docs.
- TGBridge runtime values are supplied by deployment env vars: `CFG_TGBRIDGE_BOT_TOKEN`, `CFG_TGBRIDGE_CHAT_ID`, `CFG_TGBRIDGE_TOPIC_ID`, and `CFG_TGBRIDGE_BLUEMAP_URL`.
- BlueMap runs its own webserver on port `8100`; deployment is responsible for publishing or proxying it.
- Server tuning changes in `modconfig/servercore/` should be documented when they materially affect gameplay, performance, or operational expectations.

## Documentation Rules

- Keep `README.md`, `docs/modpack.md`, and `docs/mods.md` aligned when release flow, artifact names, image names, or mod inventory changes.
- The pinned mod count in `docs/mods.md` must match the number of `modpack/mods/*.pw.toml` files.
- Use Russian for existing Russian docs unless the surrounding file is already English.
