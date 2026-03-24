# Core Versions — OpenEmuARM64

_Last audited: 2026-03-23_

This document records the upstream version each emulator core source was based on when it was committed to this repo. Because the cores are flattened (not tracked as git submodules), this is the reference point for future updates — if a bug needs fixing upstream, start by diffing against the version listed here.

**Confidence key:**
- ✅ Confirmed — version string found directly in a source header or ChangeLog
- ⚠️ Estimated — inferred from commit message, file naming, or ChangeLog top entry (may be approximate)
- ❓ Unknown — no version marker found; upstream comparison required

---

## Core Version Table

| Core | Systems | Upstream Repo | Version in Repo | Confidence | Notes |
|------|---------|--------------|----------------|-----------|-------|
| 4DO | 3DO | [libretro/4do-libretro](https://github.com/libretro/4do-libretro) | Unknown | ❓ | No version header found in source |
| Atari800 | Atari 5200, Atari 8-bit | [atari800/atari800](https://github.com/atari800/atari800) | 3.1.0 | ✅ | `PACKAGE_VERSION "3.1.0"` in config.h |
| Bliss | Intellivision | [OpenEmu/Bliss-Core](https://github.com/OpenEmu/Bliss-Core) | Unknown | ❓ | No version header found |
| blueMSX | MSX, ColecoVision | [openemulator/blueMSX](https://github.com/openemulator/bluemsx) | 2.8.3 | ✅ | `BLUE_MSX_VERSION "2.8.3"` in version.h |
| BSNES | SNES (accuracy) | [bsnes-emu/bsnes](https://github.com/bsnes-emu/bsnes) | v115 | ✅ | Explicitly noted in git commit `a6a284f6`: "populate bsnes/ source tree at v115 (commit 8e80d2f)" |
| CrabEmu | SMS, Game Gear, SG-1000, ColecoVision | [OpenEmu/CrabEmu-Core](https://github.com/OpenEmu/CrabEmu-Core) | 0.2.1 | ✅ | `VERSION "0.2.1"` in CrabEmu.h |
| DeSmuME | Nintendo DS | [TASVideos/desmume](https://github.com/TASVideos/desmume) | 0.9.11 | ✅ | ChangeLog top entry: "0.9.10 -> 0.9.11" |
| FCEU | NES | [OpenEmu/FCEU-Core](https://github.com/OpenEmu/FCEU-Core) | Unknown | ❓ | Version header exists but contains no version string |
| Flycast | Dreamcast | [flyinghead/flycast](https://github.com/flyinghead/flycast) | v2024.09.30 | ✅ | `GIT_VERSION "v2024.09.30"` in version.h; git commit `df91dcc6` notes "from flyinghead/flycast (HEAD)" at time of add |
| Gambatte | Game Boy | [OpenEmu/Gambatte-Core](https://github.com/OpenEmu/Gambatte-Core) | 0.5.1 | ✅ | ChangeLog top entry: "Version 0.5.1" |
| GenesisPlus | SMS, Game Gear, SG-1000, Sega CD | [ekeeke/Genesis-Plus-GX](https://github.com/ekeeke/Genesis-Plus-GX) | Unknown | ❓ | No version header found; CHANGELOG present belongs to libvorbis/tremor dependency |
| JollyCV | ColecoVision | [OpenEmu/JollyCV-Core](https://github.com/OpenEmu/JollyCV-Core) | 1.0.1 | ✅ | `VERSION "1.0.1"` in source header |
| Mednafen | PSX, Saturn, Lynx, Neo Geo Pocket, PC Engine, WonderSwan, others | [mednafen/mednafen](https://github.com/mednafen/mednafen) | Unknown | ❓ | `MEDNAFEN_VERSION` referenced in code but not defined inline; requires checking upstream tags |
| mGBA | Game Boy Advance | [mgba-emu/mgba](https://github.com/mgba-emu/mgba) | Unknown | ❓ | Version is set at build time via CMake template; not embedded statically in source |
| Mupen64Plus | Nintendo 64 | [mupen64plus/mupen64plus-core](https://github.com/mupen64plus/mupen64plus-core) | 2.5.9 | ✅ | `MUPEN_CORE_VERSION 0x020509` in version.h (hex: 02=2, 05=5, 09=9) |
| Nestopia | NES, Famicom Disk System | [OpenEmu/Nestopia](https://github.com/OpenEmu/Nestopia) | Unknown | ❓ | No version string found in source headers |
| O2EM | Odyssey² / Videopac | [OpenEmu/O2EM-Core](https://github.com/OpenEmu/O2EM-Core) | 1.16 | ⚠️ | Inferred from `O2EM116_private.h` filename; no explicit define found |
| picodrive | Sega 32X | [notaz/picodrive](https://github.com/notaz/picodrive) | 1.93 | ✅ | `VERSION "1.93"` in version.h |
| PokeMini | Pokémon Mini | [OpenEmu/PokeMini-Core](https://github.com/OpenEmu/PokeMini-Core) | 0.6.0 | ⚠️ | `RES_VERSION 0,6,0,0` in resource header |
| ProSystem | Atari 7800 | [OpenEmu/ProSystem-Core](https://github.com/OpenEmu/ProSystem-Core) | 1.5.2 | ✅ | ChangeLog top entry: "Version 1.5.2" |
| Reicast | Dreamcast | [reicast/reicast-emulator](https://github.com/reicast/reicast-emulator) | Custom | ⚠️ | `REICAST_VERSION "OpenEmu"` — this is a custom OpenEmu-specific build, not a tagged release; git hash field is empty |
| SNES9x | SNES | [snes9xgit/snes9x](https://github.com/snes9xgit/snes9x) | 1.62.3 | ✅ | `VERSION "1.62.3"` in snes9x.h |
| Stella | Atari 2600 | [stella-emu/stella](https://github.com/stella-emu/stella) | 3.9.3 | ✅ | `STELLA_VERSION "3.9.3"` in Version.hxx |
| VecXGL | Vectrex | [OpenEmu/VecXGL-Core](https://github.com/OpenEmu/VecXGL-Core) | Unknown | ❓ | No version header found |
| VirtualC64-Core | Commodore 64 | [dirkwhoffmann/virtualc64](https://github.com/dirkwhoffmann/virtualc64) | — | — | Directory is empty; no source present |
| VirtualJaguar | Atari Jaguar | [OpenEmu/VirtualJaguar-Core](https://github.com/OpenEmu/VirtualJaguar-Core) | Unknown | ❓ | No version string found in source headers |

---

## How to Resolve Unknowns

For cores marked ❓, the most reliable approach is to find a distinctive string in the source and search the upstream repo's git history:

```bash
# Example: find a unique string in GenesisPlus source
grep -r "unique_function_name" GenesisPlus/genplusgx_source/ | head -1

# Then search the upstream repo at that string to find the matching commit/tag
# https://github.com/ekeeke/Genesis-Plus-GX/search?q=unique_function_name
```

Alternatively, check the original OpenEmu fork (`bazley82/OpenEmuARM64`) commit history for any messages that mention version numbers for that core.

---

## How to Update a Core

When a bug fix or compatibility improvement exists in an upstream core:

1. **Find the upstream commit or tag** that contains the fix
2. **Diff against the version recorded here** to understand the scope of changes
3. **Apply the relevant changes** to the flattened source in this repo (do not blindly copy the entire tree — bazley82's ARM64 patches are mixed in)
4. **Update this file** with the new version and date
5. **Commit** with message: `chore: update <CoreName> to <version>`
6. **Build and test** before opening a PR

For new cores added going forward (PPSSPP, melonDS, Dolphin — see `docs/roadmap.md`), use git submodules or subtrees so this manual tracking is not necessary.

---

## ARM64 Patch Notes

The following cores had significant ARM64-specific patches applied by bazley82 that are not in upstream. Be careful not to overwrite these when updating:

| Core | Known ARM64 / macOS Patches |
|------|---------------------------|
| BSNES | Populated from v115 source at commit `8e80d2f`; ARM64 build fixes in Xcode project |
| Flycast | Multiple fixes: `std::result_of` → `std::invoke_result_t`, static libzip headers, TARGET_MAC support in gl_context.h, removed TARGET_IPHONE=1, macOS OpenGL 3 headers, added zip_err_str.c and network_stubs.cpp |
| Mupen64Plus | arm64 added to VALID_ARCHS in both build configurations |
| VirtualJaguar | Framebuffer hint propagated to `JaguarSetScreenBuffer` |
| DeSmuME | Pointer dereference fix in directory.cpp |
| blueMSX / Reicast | ARM64 build error fixes (commit `6ade5a1e`) |

For all other cores, ARM64 patches may exist but were not separately documented — treat the entire flattened source as potentially containing undocumented modifications relative to upstream.
