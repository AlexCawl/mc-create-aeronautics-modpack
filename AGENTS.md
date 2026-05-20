# Repository Instructions

Перед выполнением запроса пользователя всегда сначала перечитай этот файл, если он есть в корне репозитория.

## Project Principles

- Keep the repository Git-first: reproducible configuration and mod metadata live in Git, runtime state does not.
- Treat `modpack/` as the canonical source of truth for the packwiz modpack.
- Treat `data/` as disposable runtime state mounted to `/data`; never commit it.
- Do not commit `.env`, downloaded `.jar` files, generated `.mrpack` files, `dist/`, or `.cache/`.
- Keep v1 simple: no AutoModpack client-only overlay or deduplication unless explicitly requested.

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

## Minecraft Pack Rules

- Use `side = "client"`, `side = "server"`, or `side = "both"` deliberately in each `mods/*.pw.toml`.
- Mark a mod as `both` only when the exact version supports dedicated server loading or has been manually verified.
- Keep AutoModpack pinned in `modpack/` while the repository uses AutoModpack for post-bootstrap client sync.
- When adding, removing, updating, or changing the side of a mod, update `docs/mods.md` in the same commit.
