# VPS Operations

Clone the repository on the VPS and keep the server rooted in that checkout.

```sh
git clone <repo-url> mc-create-aeronautics
cd mc-create-aeronautics
```

Create `.env` locally:

```sh
MODRINTH_MODPACK=https://github.com/<owner>/<repo>/releases/download/master-latest/mc-create-aeronautics.mrpack
RCON_PASSWORD=change-me
MC_MEMORY=6G
MC_PORT=25565
MC_MOTD=Create Aeronautics
TZ=Asia/Yekaterinburg
```

Start or update:

```sh
docker compose pull
docker compose up -d
```

Runtime state is in `data/`. Back up at least:

```text
data/world/
data/world_nether/
data/world_the_end/
data/server.properties
data/ops.json
data/whitelist.json
```

Do not commit `data/`.

