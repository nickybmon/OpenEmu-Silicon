# Emulation Cores — OpenEmu-Silicon

_Last updated: 2026-03-26_

Reference for all emulation cores in the repo: current status, upstream version, and known issues.

**Version confidence key:**
- ✅ Confirmed — version string found directly in source header or ChangeLog
- ⚠️ Estimated — inferred from commit message, file naming, or ChangeLog top entry
- ❓ Unknown — no version marker found; upstream comparison required

---

## Working Cores

| Core | Systems | Upstream Version | Confidence | Notes |
|------|---------|-----------------|-----------|-------|
| 4DO | 3DO | Unknown | ❓ | |
| Atari800 | Atari 5200, Atari 8-bit | 3.1.0 | ✅ | `PACKAGE_VERSION "3.1.0"` in config.h |
| Bliss | Intellivision | Unknown | ❓ | |
| blueMSX | MSX, ColecoVision | 2.8.3 | ✅ | `BLUE_MSX_VERSION "2.8.3"` in version.h |
| CrabEmu | ColecoVision, Game Gear, SG-1000, SMS | 0.2.1 | ✅ | `VERSION "0.2.1"` in CrabEmu.h |
| FCEU | NES | Unknown | ❓ | Alternate NES core alongside Nestopia |
| Flycast | Sega Dreamcast | v2024.09.30 | ✅ | `GIT_VERSION "v2024.09.30"` in version.h. Needs BIOS: dc_boot.bin, dc_flash.bin |
| Gambatte | Game Boy | 0.5.1 | ✅ | ChangeLog top entry: "Version 0.5.1". GBC not declared — see Known Issues |
| GenesisPlus | Game Gear, SG-1000, SMS, SG, Sega CD, Genesis/MD | Unknown | ❓ | |
| JollyCV | ColecoVision | 1.0.1 | ✅ | `VERSION "1.0.1"` in source header |
| Mednafen | Atari Lynx, Neo Geo Pocket, PC Engine/CD, PC-FX, PSX, Saturn, Virtual Boy, WonderSwan | Unknown | ❓ | `MEDNAFEN_VERSION` referenced in code but defined at build time |
| mGBA | Game Boy Advance | 0.10.5 | ✅ | Updated 2026-03. GBC not declared — see Known Issues |
| Mupen64Plus | Nintendo 64 | 2.5.9 | ✅ | `MUPEN_CORE_VERSION 0x020509` in version.h. Revived 2026-03 |
| Nestopia | NES, Famicom Disk System | Unknown | ❓ | |
| O2EM | Odyssey² / Videopac | 1.16 | ⚠️ | Inferred from `O2EM116_private.h` filename |
| Picodrive | Sega 32X | 1.93 | ✅ | `VERSION "1.93"` in version.h |
| PokeMini | Pokémon Mini | 0.6.0 | ⚠️ | `RES_VERSION 0,6,0,0` in resource header. Workspace fixed 2026-03 |
| Potator | Watara Supervision | Unknown | ❓ | Workspace fixed 2026-03 |
| PPSSPP | Sony PSP | Latest stable (2026-03) | ⚠️ | Rebuilt for Apple Silicon from OpenEmu/PPSSPP-Core |
| ProSystem | Atari 7800 | 1.5.2 | ✅ | ChangeLog top entry: "Version 1.5.2" |
| SNES9x | SNES | 1.63 | ✅ | Updated 2026-03 |
| Stella | Atari 2600 | 3.9.3 | ✅ | `STELLA_VERSION "3.9.3"` in Version.hxx |
| VecXGL | Vectrex | Unknown | ❓ | |
| VirtualJaguar | Atari Jaguar | Unknown | ❓ | |

---

## Legacy / Superseded

These cores exist in the repo but are no longer the active implementation.

| Core | System | Superseded By | Notes |
|------|--------|--------------|-------|
| Reicast | Dreamcast | Flycast | Legacy core. Source kept for reference; Flycast is active. Custom OpenEmu build (`REICAST_VERSION "OpenEmu"`) — not a tagged upstream release |
| BSNES | SNES (accuracy) | SNES9x | BSNES v115 builds but is not installed by default. SNES9x is the primary SNES core. Available as an optional install for accuracy-focused use |

---

## Incomplete / Empty Directories

These directories exist but contain no working Xcode project or build artifacts.

| Core | System | Status |
|------|--------|--------|
| DeSmuME | Nintendo DS | Source files only (no xcodeproj). Last known version 0.9.11. Abandoned mid-port — melonDS is the correct path forward |
| VirtualC64-Core | Commodore 64 | Empty directory. No source, no xcodeproj |
| Frodo-Core | Commodore 64 | Empty directory. No source, no xcodeproj |

---

## Systems With No Core (Roadmap)

See [`docs/roadmap.md`](roadmap.md) for full implementation plans.

| System | Core Candidate | Phase | Notes |
|--------|---------------|-------|-------|
| Nintendo DS | melonDS | Phase 1 | Greenfield wrapper build required |
| MAME / Arcade | MAME | Phase 2 | System plugin ready; core integration needed |
| Nintendo GameCube | Dolphin | Phase 3 | Community fork exists; high complexity |
| Game Boy Color | mGBA or Gambatte | Not planned | May just be a plist identifier issue — see Known Issues |

---

## Known Issues

### Game Boy Color not declared

Neither `Gambatte` nor `mGBA` declares `openemu.system.gbc` in their `OESystemIdentifiers`. Gambatte only lists `gb`; mGBA only lists `gba`. GBC games may work at runtime but won't appear in a "Game Boy Color" system category.

**Fix:** Verify if the app has a GBC system plugin; if so, add `openemu.system.gbc` to Gambatte's or mGBA's `Info.plist`.

---

## System Status Summary

| System | Status | Core |
|--------|--------|------|
| Atari 2600 | ✅ Working | Stella 3.9.3 |
| Atari 5200 | ✅ Working | Atari800 3.1.0 |
| Atari 7800 | ✅ Working | ProSystem 1.5.2 |
| Atari 8-bit | ✅ Working | Atari800 3.1.0 |
| Atari Jaguar | ✅ Working | VirtualJaguar |
| Atari Lynx | ✅ Working | Mednafen |
| ColecoVision | ✅ Working | JollyCV / blueMSX / CrabEmu |
| Commodore 64 | ❌ No working core | — |
| Dreamcast | ✅ Working | Flycast v2024.09.30 |
| Famicom Disk System | ✅ Working | Nestopia |
| Game Boy | ✅ Working | Gambatte 0.5.1 |
| Game Boy Advance | ✅ Working | mGBA 0.10.5 |
| Game Boy Color | ⚠️ Likely works, not declared in plist | Gambatte / mGBA |
| GameCube | ❌ No core — roadmap Phase 3 | Dolphin (planned) |
| Intellivision | ✅ Working | Bliss |
| MAME / Arcade | ❌ No core — roadmap Phase 2 | MAME (planned) |
| MSX | ✅ Working | blueMSX 2.8.3 |
| Neo Geo Pocket | ✅ Working | Mednafen |
| NES | ✅ Working | Nestopia / FCEU |
| Nintendo 64 | ✅ Working | Mupen64Plus 2.5.9 |
| Nintendo DS | ❌ No core — roadmap Phase 1 | melonDS (planned) |
| Odyssey² | ✅ Working | O2EM 1.16 |
| PC Engine / TurboGrafx-16 | ✅ Working | Mednafen |
| PC-FX | ✅ Working | Mednafen |
| PlayStation | ✅ Working | Mednafen |
| Pokémon Mini | ✅ Working | PokeMini 0.6.0 |
| Saturn | ✅ Working | Mednafen |
| Sega 32X | ✅ Working | Picodrive 1.93 |
| Sega CD / Mega CD | ✅ Working | GenesisPlus |
| Sega Game Gear | ✅ Working | GenesisPlus / CrabEmu |
| Sega Genesis / Mega Drive | ✅ Working | GenesisPlus |
| Sega Master System | ✅ Working | GenesisPlus / CrabEmu |
| SG-1000 | ✅ Working | GenesisPlus / CrabEmu |
| SNES | ✅ Working | SNES9x 1.63 |
| SNES (accuracy) | ⚠️ Builds, not installed by default | BSNES v115 |
| Sony PSP | ✅ Working | PPSSPP |
| Vectrex | ✅ Working | VecXGL |
| Virtual Boy | ✅ Working | Mednafen |
| Watara Supervision | ✅ Working | Potator |
| WonderSwan | ✅ Working | Mednafen |

---

## Developer Reference: ARM64 Patch Notes

The following cores had significant ARM64-specific patches applied that are not in upstream. Be careful not to overwrite these when updating:

| Core | Known ARM64 / macOS Patches |
|------|---------------------------|
| BSNES | Populated from v115 source; ARM64 build fixes in Xcode project |
| Flycast | `std::result_of` → `std::invoke_result_t`, static libzip headers, TARGET_MAC support in gl_context.h, removed TARGET_IPHONE=1, macOS OpenGL 3 headers, added zip_err_str.c and network_stubs.cpp |
| Mupen64Plus | arm64 added to VALID_ARCHS in both build configurations |
| VirtualJaguar | Framebuffer hint propagated to `JaguarSetScreenBuffer` |
| DeSmuME | Pointer dereference fix in directory.cpp |
| blueMSX / Reicast | ARM64 build error fixes |

For all other cores, ARM64 patches may exist but were not separately documented — treat the entire flattened source as potentially containing undocumented modifications relative to upstream.

---

## How to Update a Core

1. **Find the upstream commit or tag** that contains the fix
2. **Diff against the version recorded here** to understand the scope of changes
3. **Apply the relevant changes** to the flattened source (do not blindly copy the entire tree — ARM64 patches are mixed in)
4. **Update this file** with the new version and date
5. **Commit** with message: `chore: update <CoreName> to <version>`
6. **Build and test** before opening a PR

For new cores going forward (melonDS, Dolphin — see [`docs/roadmap.md`](roadmap.md)), use git submodules or subtrees so this manual tracking is not necessary.
