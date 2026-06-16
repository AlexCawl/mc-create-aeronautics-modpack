# Конфиги

`modconfig/` содержит baseline-конфиги серверного образа. Они копируются в `/config/` внутри Docker-образа и применяются к runtime-конфигам сервера при запуске.

Клиентские конфиги, которые должны попасть в экспортированный `.mrpack`, лежат в `modpack/config/` и индексируются packwiz.

## Distant Horizons

`modpack/config/DistantHorizons.toml`:

- оставляет основной DH terrain renderer включенным через `rendererMode = "DEFAULT"`;
- отключает DH generic rendering для clouds/beacons, потому что на macOS с OpenGL этот путь может падать в native Apple Metal/OpenGL renderer;
- снижает GPU-нагрузку LOD-профилем `HALF_CHUNK`, `LOW`, `128` chunks и `FAKE` transparency, сохраняя дальние LOD-чанки;
- отключает DH SSAO, LOD dithering, far-clip fade, LOD biome blending и LOD side shading, чтобы уменьшить объем LOD-геометрии и shader-работы на macOS OpenGL;
- отключает auto-updater DH, чтобы версия мода управлялась packwiz-метаданными.

Modrinth-релиз DH `3.0.3-b` уже содержит macOS workaround для загрузки больших VBO через OpenGL: большие буферы отправляются в GPU чанками по `256 KiB`. Поэтому packwiz остается на стабильном Modrinth metadata, а клиентский конфиг дополнительно уменьшает размер и частоту проблемных OpenGL upload-путей.

## BlueMap

`modconfig/bluemap/core.conf`:

- принимает загрузку web assets через `accept-download`;
- ограничивает BlueMap одним render-thread, чтобы фоновый рендер меньше конкурировал с server thread.

`modconfig/bluemap/plugin.conf`:

- ставит рендер на паузу, пока на сервере есть хотя бы один игрок.

BlueMap webserver работает на порту `8100`; публикация или reverse proxy настраиваются в deployment-репозитории.

## C2ME

`modconfig/c2me.toml`:

- фиксирует сниженный `globalExecutorParallelism`, чтобы C2ME не забивал CPU при генерации и загрузке чанков;
- остальные параметры оставляет на дефолтах C2ME.

## ServerCore

`modconfig/servercore/config.yml`:

- основан на official optimized-профиле ServerCore;
- задает динамическое снижение `VIEW_DISTANCE`, `CHUNK_TICK_DISTANCE` и `SIMULATION_DISTANCE`;
- усиливает merge item/XP entities.

`modconfig/servercore/optimizations.yml`:

- включает official optimized-настройки ServerCore для chunk, command block, biome lookup и fluid tick оптимизаций.

## TGBridge

`modconfig/tgbridge/config.yml`:

- настраивает Telegram bridge;
- runtime-значения подставляются через `CFG_TGBRIDGE_BOT_TOKEN`, `CFG_TGBRIDGE_CHAT_ID`, `CFG_TGBRIDGE_TOPIC_ID` и `CFG_TGBRIDGE_BLUEMAP_URL`.
