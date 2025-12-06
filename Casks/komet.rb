cask "komet" do
  version "0.1.7"
  sha256 "e5d841b8eaffae7b4b63ce2c69d1651b4ca76b01893c413b98865c3453d7b601"

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
