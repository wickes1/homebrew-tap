cask "komet" do
  version "0.2.0"
  sha256 "252f0793ce641379ab22514c6a55c34124a774c8b7f579b5cb234c608810ee32"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal, lightning-fast application launcher for macOS"
  homepage "https://github.com/wickes1/Komet"

  depends_on macos: :ventura

  app "Komet.app"

  preflight_steps do
    terminate_process "Komet.app", match: :full
  end

  # Homebrew runs these steps in a sandbox that cannot launch an app (`open` fails there), so the cask
  # only clears the quarantine flag; the caveats say how to start Komet.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Komet.app"], must_succeed: false
  end

  caveats <<~EOS
    Start Komet now, and again after every upgrade (an upgrade quits it):
      open -a Komet

    Komet needs no permissions. Its hotkey is Cmd+Space: turn off Spotlight's
    shortcut in System Settings → Keyboard → Keyboard Shortcuts → Spotlight.

    Komet is unsigned. If blocked by Gatekeeper:
    1. Go to System Settings → Privacy & Security
    2. Click "Open Anyway" next to the Komet warning
  EOS

  zap trash: [
    "~/Library/Preferences/com.wickes1.komet.plist",
    "~/Library/Caches/com.wickes1.komet",
  ]
end
