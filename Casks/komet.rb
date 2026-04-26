cask "komet" do
  version "0.1.13"
  sha256 "aefbfb41a8348bed36f1a56a27626287763f25bf346197da47ebda79ba309afe"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal, lightning-fast application launcher for macOS"
  homepage "https://github.com/wickes1/Komet"

  depends_on macos: ">= :ventura"

  app "Komet.app"

  preflight do
    system_command "pkill", args: ["-f", "Komet.app"], must_succeed: false
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Komet.app"],
                   must_succeed: false
    system_command "open", args: ["#{appdir}/Komet.app"]
  end

  caveats <<~EOS
    Komet is unsigned. If blocked by Gatekeeper:
    1. Go to System Settings → Privacy & Security
    2. Click "Open Anyway" next to the Komet warning

    Komet requires Accessibility permissions:
    System Settings → Privacy & Security → Accessibility → Enable Komet

    After upgrade, re-grant Accessibility permission:
    1. Remove Komet from Accessibility list
    2. Re-add Komet
  EOS

  zap trash: [
    "~/Library/Preferences/com.wickes1.komet.plist",
    "~/Library/Caches/com.wickes1.komet",
  ]
end
