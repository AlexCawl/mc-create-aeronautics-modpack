FROM itzg/minecraft-server:java21

LABEL org.opencontainers.image.title="MC Create Aeronautics Server"
LABEL org.opencontainers.image.description="Minecraft server bootstrap image with pinned packwiz metadata."

ENV TYPE=NEOFORGE \
    VERSION=1.21.1 \
    PACKWIZ_URL=/packwiz/pack.toml \
    REMOVE_OLD_MODS=TRUE \
    REPLACE_ENV_VARIABLES=TRUE \
    ICON=/server-icon.png \
    OVERRIDE_ICON=TRUE \
    MOTD="Create Aeronautics"

COPY modpack/ /packwiz/
COPY modconfig/ /config/
COPY modpack-icon.png /server-icon.png
