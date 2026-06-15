# mc-create-aeronautics-modpack

Git-first repository for the NeoForge `1.21.1` Create Aeronautics modpack, client exports, and server bootstrap image.

## Работа с модами

`modpack/` является основным источником packwiz-модпака. Коммитьте `modpack/pack.toml`, `modpack/index.toml` и `modpack/mods/*.pw.toml`; не коммитьте скачанные `.jar`, `.mrpack`, CurseForge `.zip`, `dist/`, `site/` и `.cache/`.

Добавление Modrinth-мода:

```sh
cd modpack
packwiz modrinth add <mod-slug>
packwiz refresh
```

Добавление CurseForge-мода:

```sh
cd modpack
packwiz curseforge add <project-slug-or-id>
packwiz refresh
```

После добавления, удаления, обновления или смены стороны мода обновите [список модов](docs/mods.md). Значение `side` выбирайте явно:

- `client` - только клиент.
- `server` - только выделенный сервер.
- `both` - клиент и выделенный сервер.

## Работа с конфигами

`modconfig/` содержит baseline-конфиги серверного образа. Dockerfile копирует их в `/config/`, а образ `itzg/minecraft-server` применяет их к runtime-данным сервера при запуске. Эти файлы не индексируются packwiz.

Серверные runtime-конфиги храните в `modconfig/`. Клиентские конфиги, которые должны уехать в клиентский модпак, храните внутри `modpack/config/` и обновляйте `packwiz refresh`.

Deploy-time секреты не коммитьте. Для значений, которые должны подставляться при запуске, используйте `${CFG_*}` placeholders и переменные окружения в deployment-репозитории.

Список серверных baseline-конфигов описан в [разделе конфигов](docs/modpack.md).

## Релизы

Клиентские артефакты локально собираются так:

```sh
mkdir -p dist
cd modpack
packwiz --cache ../.cache/packwiz modrinth export -o ../dist/mc-create-aeronautics-client.mrpack
packwiz --cache ../.cache/packwiz curseforge export -o ../dist/mc-create-aeronautics-client-curseforge.zip
```

Релизы публикуются вручную через GitHub Actions `Release`. Workflow создает следующий неизменяемый тег `vN`, загружает клиентские артефакты и публикует серверный образ:

- `mc-create-aeronautics-client.mrpack`
- `mc-create-aeronautics-client-curseforge.zip`
- `ghcr.io/alexcawl/mc-create-aeronautics-server:<tag>`
- `ghcr.io/alexcawl/mc-create-aeronautics-server:latest`
