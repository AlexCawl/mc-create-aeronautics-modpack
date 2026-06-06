# Обслуживание модпака

`modpack/` содержит packwiz-метаданные. Коммитьте `pack.toml`, `index.toml` и `mods/*.pw.toml`; не коммитьте скачанные `.jar` файлы.

Базовые конфиги серверного образа лежат в `modconfig/` и копируются в `/config/` внутри Docker-образа. Образ itzg применяет их при запуске; packwiz их не индексирует.

Deploy-time значения в конфигах подставляются через env-переменные с префиксом `CFG_`. Для TGBridge задайте `CFG_TGBRIDGE_BOT_TOKEN`, `CFG_TGBRIDGE_CHAT_ID` и `CFG_TGBRIDGE_TOPIC_ID`.

## Сборка

```sh
scripts/build-mrpack.sh
```

Клиентский артефакт записывается в `dist/mc-create-aeronautics-client.mrpack`.

Чтобы локально собрать CurseForge-compatible экспорт:

```sh
cd modpack
packwiz curseforge export -o ../dist/mc-create-aeronautics-client-curseforge.zip
```

CurseForge zip — это экспортный артефакт. Перед публикацией на CurseForge может потребоваться проверить разрешения и лицензии модов не из CurseForge.

## Добавление и обновление модов

Запускайте packwiz из `modpack/`:

```sh
cd modpack
packwiz modrinth add <mod-slug>
packwiz refresh
```

Для модов, доступных только на CurseForge:

```sh
cd modpack
packwiz curseforge add <project-slug-or-id>
packwiz refresh
```

Когда меняются метаданные модов, обновляйте [список модов](mods.md) в том же коммите.

## Стороны

- `both`: устанавливается на клиент и выделенный сервер.
- `client`: устанавливается только в клиентский пак.
- `server`: устанавливается только на выделенный сервер.

Используйте самую узкую сторону, которая подходит для мода. Отмечайте мод как `both` только если конкретная версия поддерживает загрузку на выделенном сервере или была вручную проверена.

AutoModpack остается закрепленным в паке для клиентской синхронизации, видимой серверу.

## Релиз

Запускайте рабочий процесс GitHub Actions `Release` вручную. Он создает следующий неизменяемый GitHub Release с тегом `vN`, загружает оба клиентских артефакта, помечает релиз как GitHub Latest и публикует соответствующий серверный образ с Docker-тегами `vN` и `latest`:

- `mc-create-aeronautics-client.mrpack`
- `mc-create-aeronautics-client-curseforge.zip`

Стабильные ссылки на последний релиз:

- [Modrinth MrPack](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client.mrpack)
- [Экспорт CurseForge](https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client-curseforge.zip)

Теги серверного образа:

```sh
ghcr.io/alexcawl/mc-create-aeronautics-server:v1
ghcr.io/alexcawl/mc-create-aeronautics-server:latest
```
