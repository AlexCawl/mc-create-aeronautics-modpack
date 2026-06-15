# Конфиги

`modconfig/` содержит baseline-конфиги серверного образа. Они копируются в `/config/` внутри Docker-образа и применяются к runtime-конфигам сервера при запуске.

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
