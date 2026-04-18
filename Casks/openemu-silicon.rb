cask "openemu-silicon" do
  version "1.0.6"
  sha256 "10d2b65d9462390538e548bb301ad96d6bd1cebbbd29620606cc1c13e7de54ef"

  url "https://github.com/nickybmon/OpenEmu-Silicon/releases/download/v#{version}/OpenEmu-Silicon.dmg"
  name "OpenEmu Silicon"
  desc "Native Apple Silicon port of the OpenEmu multi-system emulator"
  homepage "https://github.com/nickybmon/OpenEmu-Silicon"

  depends_on macos: ">= :big_sur"

  app "OpenEmu.app"

  zap trash: [
    "~/Library/Application Support/OpenEmu",
    "~/Library/Preferences/org.openemu.OpenEmu.plist",
    "~/Library/Caches/org.openemu.OpenEmu",
  ]
end
