// Copyright (c) 2026, OpenEmu Team
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the OpenEmu Team nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import AppKit

/// Moves Intel-only (x86_64) cores from the user's OpenEmu cores directory
/// to a `Legacy/` subdirectory on the first launch of OpenEmu-Silicon.
///
/// This prevents old x86-only cores installed by the original OpenEmu app from
/// conflicting with or shadowing the bundled ARM64 cores.
///
/// Runs exactly once, guarded by the `OEDidRemoveStaleX86Cores` UserDefaults key.
/// Call `runIfNeeded()` before `loadPlugins(with:)` in AppDelegate.
enum OECoreMigration {

    private static let didRunKey = "OEDidRemoveStaleX86Cores"

    private static var coresDirectory: URL {
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let appSupport = URL(fileURLWithPath: paths.first!).appendingPathComponent("OpenEmu")
        return appSupport.appendingPathComponent("Cores")
    }

    static func runIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: didRunKey) else { return }
        defer { UserDefaults.standard.set(true, forKey: didRunKey) }

        let fm = FileManager.default
        let cores = coresDirectory
        let legacy = cores.appendingPathComponent("Legacy")

        guard fm.fileExists(atPath: cores.path) else { return }

        var movedCores: [String] = []

        let items = (try? fm.contentsOfDirectory(at: cores, includingPropertiesForKeys: nil)) ?? []
        for item in items where item.pathExtension == "oecoreplugin" {
            guard let bundle = Bundle(url: item),
                  let archs = bundle.executableArchitectures else { continue }

            let hasARM64 = archs.contains(NSNumber(value: NSBundleExecutableArchitectureARM64))
            guard !hasARM64 else { continue }

            // Intel-only core — move it to Legacy/
            do {
                try fm.createDirectory(at: legacy, withIntermediateDirectories: true)
                let dest = legacy.appendingPathComponent(item.lastPathComponent)
                if fm.fileExists(atPath: dest.path) {
                    try fm.removeItem(at: dest)
                }
                try fm.moveItem(at: item, to: dest)
                movedCores.append(item.deletingPathExtension().lastPathComponent)
            } catch {
                // Non-fatal: leave it in place if we can't move it
            }
        }

        guard !movedCores.isEmpty else { return }

        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = "Legacy Cores Moved"
            alert.informativeText = """
                OpenEmu-Silicon found \(movedCores.count == 1 ? "an Intel-only core" : "\(movedCores.count) Intel-only cores") \
                from a previous OpenEmu installation and moved \(movedCores.count == 1 ? "it" : "them") to \
                ~/Library/Application Support/OpenEmu/Cores/Legacy/ to avoid conflicts with the ARM64 cores built into this app.

                Moved: \(movedCores.joined(separator: ", "))
                """
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
}
