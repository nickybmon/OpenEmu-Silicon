// Copyright (c) 2024, OpenEmu Team
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

import Cocoa

/// Preferences pane that lets users connect/disconnect their Google Drive account
/// for the Save Sync feature and see the current connection status.
final class PrefCloudSyncController: NSViewController {
    
    // MARK: - UI Elements
    
    private let headerLabel       = NSTextField(labelWithString: "")
    private let descLabel         = NSTextField(wrappingLabelWithString: "")
    private let signInButton      = NSButton()
    private let signOutButton     = NSButton()
    private let statusDot         = NSTextField(labelWithString: "●")
    private let statusLabel       = NSTextField(labelWithString: "")
    private let divider           = NSBox()
    private let lastSyncedLabel   = NSTextField(labelWithString: "")
    private let syncNowButton     = NSButton()
    private let syncInfoLabel     = NSTextField(wrappingLabelWithString: "")
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }()
    
    // MARK: - Notification Token
    
    private var syncStatusToken: NSObjectProtocol?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 468, height: 340))
        buildUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatus()
        
        syncStatusToken = NotificationCenter.default.addObserver(
            forName: .OESaveSyncStatusDidChange,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateStatus()
        }
    }
    
    deinit {
        if let token = syncStatusToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    // MARK: - Build UI
    
    private func buildUI() {
        // ── Header ──────────────────────────────────────────────────
        headerLabel.stringValue = "Google Drive Cloud Sync"
        headerLabel.font = .boldSystemFont(ofSize: 15)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerLabel)
        
        // ── Description ─────────────────────────────────────────────
        descLabel.stringValue = "Sign in with Google to automatically back up your battery saves and save states. When launching a game, OpenEmu will check whether a newer save is available in the cloud and offer to download it."
        descLabel.font = .systemFont(ofSize: 12)
        descLabel.textColor = .secondaryLabelColor
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descLabel)
        
        // ── Status Row ───────────────────────────────────────────────
        statusDot.font = .systemFont(ofSize: 14)
        statusDot.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusDot)
        
        statusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        // ── Sign In Button ───────────────────────────────────────────
        signInButton.title = "Sign In with Google"
        signInButton.bezelStyle = .rounded
        signInButton.controlSize = .large
        signInButton.font = .systemFont(ofSize: 13, weight: .semibold)
        signInButton.target = self
        signInButton.action = #selector(signIn)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        // Use the Google brand colour as much as AppKit allows.
        signInButton.contentTintColor = NSColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1)
        view.addSubview(signInButton)
        
        // ── Sign Out Button ──────────────────────────────────────────
        signOutButton.title = "Sign Out"
        signOutButton.bezelStyle = .rounded
        signOutButton.controlSize = .regular
        signOutButton.font = .systemFont(ofSize: 12)
        signOutButton.target = self
        signOutButton.action = #selector(signOut)
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signOutButton)
        
        // ── Last Synced Label ────────────────────────────────────────
        lastSyncedLabel.font = .systemFont(ofSize: 11)
        lastSyncedLabel.textColor = .secondaryLabelColor
        lastSyncedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lastSyncedLabel)
        
        // ── Sync Now Button ──────────────────────────────────────────
        syncNowButton.title = "Sync Now"
        syncNowButton.bezelStyle = .rounded
        syncNowButton.controlSize = .small
        syncNowButton.font = .systemFont(ofSize: 11)
        syncNowButton.target = self
        syncNowButton.action = #selector(syncNow)
        syncNowButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(syncNowButton)
        
        // ── Divider ──────────────────────────────────────────────────
        divider.boxType = .separator
        divider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(divider)
        
        // ── Sync Info ────────────────────────────────────────────────
        syncInfoLabel.stringValue = "Saves are stored in a hidden App Data folder in your Google Drive that only OpenEmu can access. No other files in your Drive are visible to OpenEmu."
        syncInfoLabel.font = .systemFont(ofSize: 11)
        syncInfoLabel.textColor = .tertiaryLabelColor
        syncInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(syncInfoLabel)
        
        // ── Layout ───────────────────────────────────────────────────
        NSLayoutConstraint.activate([
            // Header
            headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            // Description
            descLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            // Status dot + label
            statusDot.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 24),
            statusDot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            
            statusLabel.centerYAnchor.constraint(equalTo: statusDot.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusDot.trailingAnchor, constant: 6),
            
            // Sign In button
            signInButton.topAnchor.constraint(equalTo: statusDot.bottomAnchor, constant: 20),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            signInButton.widthAnchor.constraint(equalToConstant: 180),
            
            // Sign Out button — right-aligned next to Sign In
            signOutButton.centerYAnchor.constraint(equalTo: signInButton.centerYAnchor),
            signOutButton.leadingAnchor.constraint(equalTo: signInButton.trailingAnchor, constant: 12),
            
            // Divider
            divider.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 28),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Privacy note
            syncInfoLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 14),
            syncInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            syncInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            
            // Last Synced
            lastSyncedLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            lastSyncedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            
            // Sync Now
            syncNowButton.centerYAnchor.constraint(equalTo: lastSyncedLabel.centerYAnchor),
            syncNowButton.leadingAnchor.constraint(equalTo: lastSyncedLabel.trailingAnchor, constant: 8),
        ])
    }
    
    // MARK: - Status Update
    
    private func updateStatus() {
        let isSignedIn = OESaveSyncManager.shared.isSignedIn
        
        if isSignedIn {
            statusDot.textColor    = NSColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)  // green
            statusLabel.stringValue = "Connected"
            statusLabel.textColor   = NSColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)
        } else {
            statusDot.textColor    = NSColor(red: 0.87, green: 0.20, blue: 0.18, alpha: 1) // red
            statusLabel.stringValue = "Not Connected"
            statusLabel.textColor   = NSColor(red: 0.87, green: 0.20, blue: 0.18, alpha: 1)
        }
        
        signInButton.isHidden  = isSignedIn
        signOutButton.isHidden = !isSignedIn
        
        syncNowButton.isHidden = !isSignedIn
        if isSignedIn {
            if let date = OESaveSyncManager.shared.lastSyncDate {
                lastSyncedLabel.stringValue = "Last synced: \(dateFormatter.string(from: date))"
            } else {
                lastSyncedLabel.stringValue = "Not synced yet"
            }
        } else {
            lastSyncedLabel.stringValue = ""
        }
    }
    
    // MARK: - Actions
    
    @objc private func signIn() {
        OESaveSyncManager.shared.signIn()
    }
    
    @objc private func signOut() {
        let alert = NSAlert()
        alert.messageText     = "Sign Out of Google Drive?"
        alert.informativeText = "Your local saves will not be affected. You can sign back in at any time."
        alert.addButton(withTitle: "Sign Out")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        
        guard alert.runModal() == .alertFirstButtonReturn else { return }
        OESaveSyncManager.shared.signOut()
        updateStatus()
    }
    
    @objc private func syncNow() {
        OESaveSyncManager.shared.performFullSyncCheck()
    }
}

// MARK: - PreferencePane

extension PrefCloudSyncController: PreferencePane {
    
    var icon: NSImage? {
        // Use the built-in iCloud/cloud SF Symbol (available macOS 11+), fallback to nil.
        if #available(macOS 11.0, *) {
            return NSImage(systemSymbolName: "icloud.and.arrow.up", accessibilityDescription: "Cloud Sync")
        }
        return NSImage(named: NSImage.networkName)
    }
    
    var panelTitle: String { "Cloud Sync" }
    
    var viewSize: NSSize { NSSize(width: 468, height: 340) }
}
