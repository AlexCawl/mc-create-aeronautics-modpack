# VPS Operations

Clone the repository on the VPS and keep the server rooted in that checkout:

```sh
git clone <repo-url> mc-create-aeronautics
cd mc-create-aeronautics
```

## Configuration

Create `.env` locally on the VPS. This file is intentionally ignored and no `.env.example` is committed.

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/master-latest/mc-create-aeronautics.mrpack
RCON_PASSWORD=change-me
GRAFANA_ADMIN_PASSWORD=change-me-too
MC_MEMORY=6G
MC_PORT=25565
VOICE_CHAT_PORT=24454
MC_MOTD=Create Aeronautics
TZ=Asia/Yekaterinburg
```

Use `master-latest` when the server should track the current `master` build. Use an immutable release URL such as `v0.1.0` when the server should stay pinned.

`MC_PORT` publishes the Minecraft TCP port. `VOICE_CHAT_PORT` publishes the Simple Voice Chat UDP port, so the VPS firewall and provider firewall must allow UDP `24454` when voice chat should work outside the container host.

## Server Commands

Start or update the server:

```sh
docker compose pull
docker compose up -d
```

Stop it:

```sh
docker compose down
```

Follow logs:

```sh
docker compose logs -f minecraft
```

Open Grafana through an SSH tunnel:

```sh
ssh -L 3000:127.0.0.1:3000 <user>@<vps-host>
```

Then open `http://localhost:3000`.

## Runtime Data

`data/` is mounted as `/data` in the container and contains world data, logs, crash reports, downloaded jars, generated configs, and AutoModpack runtime state.

Do not commit `data/`.

Prometheus and Grafana store runtime state in Docker named volumes.

## Backups

Runtime state is in `data/`. Back up at least:

```text
data/world/
data/world_nether/
data/world_the_end/
data/server.properties
data/ops.json
data/whitelist.json
```
