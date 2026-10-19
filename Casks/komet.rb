cask "komet" do
  version "0.1.15"
  sha256 "014c616ad4a565fc48709a1cb5ae565b0df5ecafb9270863dcb0557f33a8c23b"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal, lightning-fast application launcher for macOS"
  homepage "https://github.com/wickes1/Komet"

  depends_on macos: :ventura

  app "Komet.app"

  preflight_steps do
    terminate_process "Komet.app", match: :full
  end

  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Komet.app"], must_succeed: false
    run "/usr/bin/open", args: ["{{appdir}}/Komet.app"], must_succeed: false
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
