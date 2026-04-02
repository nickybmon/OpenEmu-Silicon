# Contributors

OpenEmu-Silicon stands on the shoulders of a lot of excellent work that came before it. This file honors that lineage.

---

## Original OpenEmu Project

The original OpenEmu application was built by the OpenEmu Team — a group of developers who created one of the best pieces of Mac software ever made.

- **OpenEmu/OpenEmu** — https://github.com/OpenEmu/OpenEmu

The full contributor history for the original project is preserved in that repository.

---

## ARM64 Port Foundation

The foundational work of porting all emulation cores to build natively on Apple Silicon was done by bazley82.

- **bazley82/OpenEmuARM64** — https://github.com/bazley82/OpenEmuARM64
  - Systematic ARM64 port of all 25 emulation cores
  - App update via GitHub (Sparkle) and Per-Core Revert feature
  - Core Preferences UI refactor
  - VirtualC64 core for Commodore 64
  - Appcast infrastructure

Earlier foundational work in the same lineage by **Barrie Sanders**:
  - Google Drive Save Sync Manager (ARM64 native)
  - Initial ARM64 port finalization, Cloud Sync scaffolding, and localization

---

## Emulator Core Sources

The emulation cores in this repo are derived from the following upstream projects. Wrapper code (OEGameCore subclasses, Xcode project files) originates from OpenEmu's core repositories.

| Core | Upstream Project |
|------|----------------|
| Gambatte, FCEU, Nestopia, SNES9x, Mupen64Plus, mGBA, GenesisPlus, Mednafen, Stella, Atari800, Bliss, JollyCV, O2EM, PokeMini, Potator, ProSystem, VecXGL, VirtualJaguar, CrabEmu, blueMSX, 4DO, picodrive, Reicast/Flycast, BSNES | OpenEmu core repositories — https://github.com/OpenEmu |
| PPSSPP | OpenEmu/PPSSPP-Core wrapper — https://github.com/OpenEmu/PPSSPP-Core, against PPSSPP 1.14.4 source. Prebuilt FFmpeg libs from hrydgard/ppsspp-ffmpeg — https://github.com/hrydgard/ppsspp-ffmpeg |
| Dolphin (GameCube/Wii) | dolphin-emu/dolphin — https://github.com/dolphin-emu/dolphin, pinned to the 2603 release. OpenEmu Metal backend integration layer written for this project. |

---

## OpenEmu-Silicon

Continued development, macOS compatibility updates, and community infrastructure for this repository.

- **nickybmon** — https://github.com/nickybmon

---

## Contributors to This Repository

- **pystIC** — https://github.com/pystIC
  Review of [pystIC/OpenEmuARM64-metal4-shaders-core-updates](https://github.com/pystIC/OpenEmuARM64-metal4-shaders-core-updates) identified the Metal 4 shader version crash fix and fast math optimization landed in [PR #44](https://github.com/nickybmon/OpenEmu-Silicon/pull/44), and flagged the mGBA and SNES9x upstream version gaps tracked in [#42](https://github.com/nickybmon/OpenEmu-Silicon/issues/42) and [#43](https://github.com/nickybmon/OpenEmu-Silicon/issues/43).

<!-- Contributors: your name and GitHub profile link will be added here as PRs are merged. -->

If you've contributed a fix, feature, or improvement to this repository and your name isn't listed here, please open a PR to add it.

---

## App Icon

- **hectorlizard** — App icon design, sourced from [macosicons.com](https://macosicons.com/u/hectorlizard)

---

*The complete commit history for the upstream projects lives in their respective repositories linked above. This file acknowledges the lineage this project descends from.*
