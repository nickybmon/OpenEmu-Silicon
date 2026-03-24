# OpenEmu-Silicon: Missing Systems Roadmap

_Last updated: 2026-03-23_

This document is the single source of truth for integrating the three systems that have stub plugins in OpenEmu-Silicon but no working emulator core: **PSP**, **Nintendo DS**, and **GameCube**. Each phase is self-contained enough that a new contributor could pick it up cold.

---

## Overview & Prioritization

| System | Core Candidate | Status | Effort | Phase |
|--------|---------------|--------|--------|-------|
| Sony PSP | PPSSPP-Core | Official OE wrapper exists, dormant | ~2–3 days | 1 |
| Nintendo DS | melonDS | No wrapper; greenfield build | ~1–2 weeks | 2 |
| Nintendo GameCube | Dolphin | Community fork exists, unsupported | ~3–5 weeks | 3 |

**Ordering rationale:** Phase 1 is a revival of existing wrapper code. Phase 2 is greenfield but tractable (clean codebase, clear precedent). Phase 3 has the highest complexity and maintenance burden — do it last.

---

## Phase 1: PSP (PPSSPP-Core)

### Status

An official `OpenEmu/PPSSPP-Core` repo exists with all wrapper code already written. It is dormant — last synced against an older PPSSPP tag — but the architectural work is done. This is a revival, not a greenfield build.

### Steps

1. **Add PPSSPP-Core as a sibling directory.** Mirror the pattern of `Flycast/` and `Mupen64Plus/`:
   ```
   OpenEmuARM64/
   └── PPSSPP/          ← new top-level directory
       ├── PPSSPP-Core/ ← clone of OpenEmu/PPSSPP-Core
       └── ppsspp/      ← PPSSPP source (submodule or subtree, pinned to latest stable tag)
   ```

2. **Update the PPSSPP submodule** inside `PPSSPP-Core/` to the latest stable PPSSPP tag.

3. **Apply the standard ARM64/macOS fixes** already proven on other cores:
   - Set `FRAMEWORK_SEARCH_PATHS = $(BUILT_PRODUCTS_DIR)` in the Xcode project
   - Add the project to `OpenEmu-metal.xcworkspace/contents.xcworkspacedata`
   - Create `OpenEmu-metal.xcworkspace/xcshareddata/xcschemes/OpenEmu + PPSSPP.xcscheme`

4. **Fix compile errors iteratively.** Likely issues: narrowing conversions, C++20 deprecations in PPSSPP source, and possibly changes in PPSSPP's `NativeApp.cpp` interface since the wrapper was last synced. These are wrapper-level conflicts, not architectural changes.

5. **Sign and install the plugin:**
   ```bash
   cp -R PPSSPP/build/Debug/PPSSPP.oecoreplugin \
     ~/Library/Application\ Support/OpenEmu/Cores/
   codesign --force --sign - \
     ~/Library/Application\ Support/OpenEmu/Cores/PPSSPP.oecoreplugin
   ```

6. **Enable in the app.** Toggle PSP on in Preferences → Systems.

7. **Test** with a `.iso` or `.cso` PSP ROM.

### Risk

PPSSPP's `NativeApp.cpp` interface may have changed since `PPSSPP-Core`'s last sync. Expect merge conflicts in the wrapper glue code. The underlying architecture (how `PPSSPPGameCore` calls into PPSSPP) should be sound.

### Success Criteria

- `PPSSPP.oecoreplugin` installs and loads without crashing
- A PSP `.iso` ROM launches and renders frames
- Basic input (d-pad, face buttons, analog) is functional

---

## Phase 2: Nintendo DS (melonDS)

### Status

No existing OpenEmu wrapper for melonDS. DeSmuME in the repo is abandoned mid-port (source files present, no `.xcodeproj`) — do not attempt to revive it. melonDS is the correct modern base: ARM64 native, actively maintained, clean codebase with a clear public API.

### Steps

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

6. **Add to workspace + create scheme + sign + install + test** (same process as Phase 1 step 3–7).

### Technical Notes

**BIOS files required.** melonDS requires three firmware dumps:
- `bios7.bin` (ARM7 BIOS, 16 KB)
- `bios9.bin` (ARM9 BIOS, 4 KB)
- `firmware.bin` (DS firmware, 256 KB)

Place them in: `~/Library/Application Support/OpenEmu/Bios/`

Document this in the app's preferences or in a user-facing note — melonDS will not boot without them.

**JIT on first pass.** Disable melonDS's JIT recompiler in the initial integration. The interpreter is more portable and avoids ARM64-specific JIT issues during bring-up. Re-enable JIT in a follow-up once baseline functionality is confirmed.

**melonDS API stability.** The `NDS::` namespace is not contractually stable. Pin to a specific tag and note the pinned version in the Xcode project comments. Do not blindly pull HEAD.

### Risk

melonDS's public API can change between minor versions. Pin to a tag; don't follow HEAD. The dual-screen rendering approach (combined buffer) is a known limitation — some UI polish may be lost, but it is the only practical approach without OE framework changes.

### Success Criteria

- `melonDS.oecoreplugin` installs and loads without crashing
- A `.nds` ROM boots with BIOS files present
- Top and bottom screens render in the combined framebuffer
- Touch input routes correctly to the bottom screen
- Audio plays without significant distortion

---

## Phase 3: GameCube (Dolphin)

### Status

A community fork (`duckey77/Dolphin-Core`) wraps Dolphin as an OpenEmu core plugin. It is explicitly unsupported and carries known rendering and audio issues tied to Dolphin's internals. It is nonetheless the best starting point — the architectural work of bridging Dolphin to OEGameCore has been done.

Phase 3 is divided into sub-phases. **3a (compiles, doesn't crash) is the goal for the initial PR.** 3b–3d are follow-on work.

### Sub-phases

| Sub-phase | Goal |
|-----------|------|
| **3a** | App builds cleanly, plugin loads, ROM boots (OpenGL renderer, known issues accepted) |
| **3b** | Metal renderer working |
| **3c** | Audio stable |
| **3d** | Save states (if Dolphin's state system can be exposed via OEGameCore) |

### Steps

1. **Fork `duckey77/Dolphin-Core`** into `chris-p-bacon-sudo/Dolphin-Core`.

2. **Add `Dolphin/` as a local mirror.** Point the submodule at your fork so you control the integration branch.

3. **Update Dolphin submodule** to a recent stable tag. Dolphin releases approximately quarterly — use a tagged release, not a commit hash.

4. **Apply standard ARM64/macOS fixes** (framework paths, workspace entry, scheme) — same as every other core.

5. **Fix ARM64/macOS 26 compile errors.** Given Dolphin's size (~1M LOC), expect significant volume. Work through them systematically; don't batch-fix blindly.

6. **3a target: accept OpenGL renderer.** The `DolphinGameCore.mm` in `duckey77/Dolphin-Core` uses OpenGL. Ship 3a with OpenGL. Metal integration is a follow-on sub-phase.

7. **3b: Metal renderer.** Dolphin must share the OpenEmu Metal view with its Metal device. This requires threading changes — Dolphin's GPU thread must be handed a `CAMetalLayer` from OE. Non-trivial; scope as its own PR.

8. **3c: Audio.** Dolphin's audio backend needs a custom implementation to route output through `OERingBuffer`. The default DSP-HLE output does not map cleanly to OE's ring buffer model.

9. **Sign + install + test** with a `.iso` GameCube ROM.

10. **Document known limitations explicitly** in the PR description and in-app (if possible):
    - No save states (initially)
    - Audio stutter on first boot
    - OpenGL renderer until 3b
    - Performance varies by game complexity

### Risk Flags

| Risk | Notes |
|------|-------|
| Threading model | Dolphin runs CPU and GPU on separate threads. OpenEmu's frame execution contract is single-threaded. This is the biggest architectural mismatch and the most likely source of hard-to-debug crashes. |
| macOS 26 / Xcode 26 | Dolphin's Xcode project compatibility with Xcode 26 is unknown. Expect project-level issues independent of code. |
| Metal renderer | Sharing the OE Metal view with Dolphin's Metal device is non-trivial. Requires understanding both OE's render pipeline and Dolphin's VideoBackends architecture. |
| Maintenance burden | Dolphin is actively developed. Keeping `Dolphin-Core` in sync with upstream Dolphin is an ongoing cost, not a one-time fix. |

### Success Criteria (3a)

- `Dolphin.oecoreplugin` installs and loads without crashing
- A GameCube `.iso` boots and renders frames (OpenGL)
- Basic input is functional
- Known limitations are documented in the PR

---

## Out of Scope

These systems are explicitly not planned for this fork:

| System | Reason |
|--------|--------|
| Nintendo Wii | Dolphin supports Wii, but Wii integration adds significant complexity on top of Phase 3. Tackle after GameCube is stable. |
| Nintendo 3DS | Citra/Lime3DS exist but have never had an OpenEmu wrapper. Significant bring-up cost. |
| PlayStation 2 | PCSX2 has never had a working OpenEmu integration. Very high complexity. |
| PlayStation Portable (Vita) | No suitable emulator with a clean embedding API. |
| Nintendo Switch | Yuzu/Ryujinx are not suitable for plugin embedding. |

---

## How to Contribute

**Branch naming:**
- `feat/ppsspp-core` — Phase 1
- `feat/melon-ds-core` — Phase 2
- `feat/dolphin-core-3a` — Phase 3a, etc.

**PR format:** Follow `.github/PULL_REQUEST_TEMPLATE.md`. Each sub-phase should be its own PR — do not batch Phase 3a+3b into one PR.

**Upstream PRs:** Open against `bazley82/OpenEmuARM64` from `chris-p-bacon-sudo:<branch>`. Suggest labels in the PR description (`enhancement`, and the relevant `core:` label once the maintainer creates them).

**Before opening a PR:** Verify the plugin loads without crashing on a clean macOS 26 install and that a ROM boots. A working demo video in the PR description is strongly encouraged.
