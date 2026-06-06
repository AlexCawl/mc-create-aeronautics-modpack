FROM itzg/minecraft-server:java21

LABEL org.opencontainers.image.title="MC Create Aeronautics Server"
LABEL org.opencontainers.image.description="Minecraft server bootstrap image with pinned packwiz metadata."

ENV TYPE=NEOFORGE \
    VERSION=1.21.1 \
    PACKWIZ_URL=/packwiz/pack.toml \
    REMOVE_OLD_MODS=TRUE \
    REMOVE_OLD_MODS_DEPTH=1 \
    MOTD="Create Aeronautics"

COPY modpack/ /packwiz/
COPY modconfig/ /config/
