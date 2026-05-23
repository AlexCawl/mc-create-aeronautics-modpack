# MC Create Aeronautics

Git-first source for the NeoForge 1.21.1 Create Aeronautics modpack and its server bootstrap image.

<p class="download-actions">
  <a class="download-button download-button-primary" href="https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client.mrpack">Скачать MrPack</a>
  <a class="download-button" href="https://github.com/AlexCawl/mc-create-aeronautics-modpack/releases/latest/download/mc-create-aeronautics-client-curseforge.zip">Скачать CurseForge</a>
</p>

- `modpack/` is the canonical packwiz source.
- Manual releases publish immutable `vN` GitHub releases and mark the current release as GitHub Latest.
- GitHub Latest always exposes the current Modrinth `.mrpack` and CurseForge `.zip` client pack artifacts.
- The matching server image is published under the same `vN` tag and as `latest`.
- Deployment files live in a separate repository.

Docs:

- [Modpack maintenance](modpack.md)
- [Pinned mods](mods.md)
