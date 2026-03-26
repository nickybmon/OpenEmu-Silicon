# OpenEmu-Silicon: Roadmap

_Last updated: 2026-03-26_

This document tracks active integration plans for systems not yet supported in OpenEmu-Silicon, as well as ongoing maintenance work across all cores.

---

## Recently Completed

These were previously on the roadmap and have shipped:

| System | Core | Completed | Notes |
|--------|------|-----------|-------|
| Sony PSP | PPSSPP-Core | 2026-03 | Rebuilt from OpenEmu/PPSSPP-Core for Apple Silicon |
| Nintendo 64 | Mupen64Plus | 2026-03 | Revived; fully working |
| Sega Dreamcast | Flycast | 2026-03 | Migrated from stale Reicast codebase |
| Pokémon Mini | PokeMini | 2026-03 | Workspace integration fixed |
| Watara Supervision | Potator | 2026-03 | Workspace integration fixed |

---

## Active Roadmap

### Phase 1: Nintendo DS (melonDS)

**Status:** Planned — greenfield wrapper build required.

DeSmuME in the repo is abandoned mid-port (source files present, no `.xcodeproj`) — do not attempt to revive it. melonDS is the correct modern base: ARM64 native, actively maintained, clean codebase with a clear public API.

#### Steps

1. **Create `melonDS/` directory.** Add melonDS source as a git subtree pinned to a stable tag (e.g. `0.9.5`):
   ```bash
   git subtree add --prefix melonDS/melonDS \
     https://github.com/melonDS-emu/melonDS.git 0.9.5 --squash
   ```

2. **Create `melonDS/Xcode/melonDS.xcodeproj`.** Target type: `com.apple.product-type.bundle`, `WRAPPER_EXTENSION = oecoreplugin`.

3. **Write `melonDS/Xcode/OpenEmu/MelonDSGameCore.h`.** Declare the `OEDSSystemResponderClient` protocol (buttons: A, B, X, Y, D-pad, L, R, Start, Select, touch).

4. **Write `melonDS/Xcode/OpenEmu/MelonDSGameCore.mm`.** Implement `OEGameCore`:

   | Method | Implementation |
   |--------|---------------|
   | `loadFileAtPath:` | Load `.nds` ROM via `NDS::LoadROM()` |
   | `executeFrame` | Call `NDS::RunFrame()`; blit framebuffer |
   | Dual-screen | Render 256×192 top + 256×192 bottom into a combined 256×384 buffer. Declare `aspectSize = {4, 3}`. No OE API exists for split screens — combined buffer is the correct approach. |
   | Touch input | Map `didMoveDSPointer:` to `NDS::TouchScreen()` / `NDS::ReleaseScreen()` |
   | Audio | Route melonDS 16-bit stereo output to `OERingBuffer` |

5. **Write `melonDS/Xcode/Info.plist`.** Declare:
   ```xml
   <key>OESystemIdentifiers</key>
   <array>
     <string>openemu.system.nds</string>
   </array>
   ```

6. **Add to workspace + create scheme + sign + install + test** (same process as other cores).

#### Technical Notes

**BIOS files required.** melonDS requires three firmware dumps:
- `bios7.bin` (ARM7 BIOS, 16 KB)
- `bios9.bin` (ARM9 BIOS, 4 KB)
- `firmware.bin` (DS firmware, 256 KB)

Place them in: `~/Library/Application Support/OpenEmu/Bios/`

**JIT on first pass.** Disable melonDS's JIT recompiler in the initial integration. The interpreter is more portable and avoids ARM64-specific JIT issues during bring-up. Re-enable JIT in a follow-up once baseline functionality is confirmed.

**melonDS API stability.** The `NDS::` namespace is not contractually stable. Pin to a specific tag and note the pinned version in the Xcode project comments. Do not blindly pull HEAD.

#### Success Criteria

- `melonDS.oecoreplugin` installs and loads without crashing
- A `.nds` ROM boots with BIOS files present
- Top and bottom screens render in the combined framebuffer
- Touch input routes correctly to the bottom screen
- Audio plays without significant distortion

---

### Phase 2: MAME / Arcade

**Status:** Planned — system plugin and UI are in place; emulation core is missing.

OpenEmu-Silicon has a MAME system plugin entry, but no working MAME core is integrated. MAME itself is a large, complex codebase and requires a custom OpenEmu wrapper.

#### Approach

MAME has previously had experimental OpenEmu integrations in the community. The most tractable path is:

1. Identify the best-maintained community MAME-Core fork (search GitHub for `OpenEmu MAME` wrappers).
2. Add MAME source as a subtree pinned to a stable release tag.
3. Build the OEGameCore wrapper targeting `libmame` with a fixed ROM path convention.
4. Focus initial integration on a small, well-documented arcade system (e.g. CPS-1) before attempting broad MAME ROM support.

#### Risk

MAME's sheer size (~1.5M LOC) and its dynamic ROM database model make this more complex than other cores. It will require scoping carefully — "MAME support" as a concept is much larger than a single `.oecoreplugin`.

---

### Phase 3: GameCube / Dolphin

**Status:** Planned — community fork exists; high complexity.

A community fork (`duckey77/Dolphin-Core`) wraps Dolphin as an OpenEmu core plugin. It is explicitly unsupported and carries known rendering and audio issues tied to Dolphin's internals. It is nonetheless the best starting point.

Phase 3 is divided into sub-phases. **3a (compiles, doesn't crash) is the goal for the initial PR.** 3b–3d are follow-on work.

#### Sub-phases

| Sub-phase | Goal |
|-----------|------|
| **3a** | App builds cleanly, plugin loads, ROM boots (OpenGL renderer, known issues accepted) |
| **3b** | Metal renderer working |
| **3c** | Audio stable |
| **3d** | Save states (if Dolphin's state system can be exposed via OEGameCore) |

#### Steps

1. **Fork `duckey77/Dolphin-Core`** into `chris-p-bacon-sudo/Dolphin-Core`.
2. **Add `Dolphin/` as a local mirror.** Point the submodule at your fork so you control the integration branch.
3. **Update Dolphin submodule** to a recent stable tag. Use a tagged release, not a commit hash.
4. **Apply standard ARM64/macOS fixes** (framework paths, workspace entry, scheme).
5. **Fix ARM64/macOS 26 compile errors.** Given Dolphin's size (~1M LOC), expect significant volume. Work through them systematically.
6. **3a target: accept OpenGL renderer.** Ship 3a with OpenGL; Metal integration is a follow-on sub-phase.
7. **3b: Metal renderer.** Dolphin must share the OpenEmu Metal view with its Metal device. Requires threading changes — non-trivial; scope as its own PR.
8. **3c: Audio.** Route Dolphin's audio output through `OERingBuffer`.
9. **Sign + install + test** with a `.iso` GameCube ROM.
10. **Document known limitations explicitly** in the PR and in-app notes.

#### Risk Flags

| Risk | Notes |
|------|-------|
| Threading model | Dolphin runs CPU and GPU on separate threads. OpenEmu's frame execution contract is single-threaded. Biggest architectural mismatch. |
| macOS 26 / Xcode 26 | Dolphin's Xcode project compatibility with Xcode 26 is unknown. |
| Metal renderer | Sharing the OE Metal view with Dolphin's Metal device is non-trivial. |
| Maintenance burden | Dolphin is actively developed. Keeping Dolphin-Core in sync is an ongoing cost. |

#### Success Criteria (3a)

- `Dolphin.oecoreplugin` installs and loads without crashing
- A GameCube `.iso` boots and renders frames (OpenGL)
- Basic input is functional
- Known limitations are documented in the PR

---

## Ongoing: Core Version Updates

All cores should be kept reasonably close to their upstream stable releases. Current update status:

| Core | Current Version | Notes |
|------|----------------|-------|
| SNES9x | 1.63 | Updated 2026-03 |
| mGBA | 0.10.5 | Updated 2026-03 |
| Flycast | 2024.09.30 | |
| Mupen64Plus | 2.5.9 | |
| Others | Various | See [`docs/cores.md`](cores.md) for full audit |

Updating a core generally means: pulling the latest stable tag, resolving any API changes in the OEGameCore wrapper, rebuilding, and verifying the core still functions.

---

## Out of Scope

These systems are explicitly not planned for this fork at this time:

| System | Reason |
|--------|--------|
| Nintendo Wii | Dolphin supports Wii, but Wii integration adds significant complexity on top of Phase 3. Tackle after GameCube is stable. |
| Nintendo 3DS | Citra/Lime3DS exist but have never had an OpenEmu wrapper. Significant bring-up cost. |
| PlayStation 2 | PCSX2 has never had a working OpenEmu integration. Very high complexity. |
| PlayStation Vita | No suitable emulator with a clean embedding API. |
| Nintendo Switch | Yuzu/Ryujinx are not suitable for plugin embedding. |

---

## How to Contribute

**Branch naming:**
- `feat/melon-ds-core` — Phase 1
- `feat/mame-core` — Phase 2
- `feat/dolphin-core-3a` — Phase 3a, etc.

**PR format:** Follow `.github/PULL_REQUEST_TEMPLATE.md`. Each sub-phase should be its own PR.

**Before opening a PR:** Verify the plugin loads without crashing on a clean macOS 26 install and that a ROM boots. A working demo video in the PR description is strongly encouraged.
