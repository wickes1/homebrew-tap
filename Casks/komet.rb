cask "komet" do
  version "0.2.2"
  sha256 "3130ed01628153241755beaf3b739f90ab1fd2ecb19d242312f6daa14dfedc40"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal, lightning-fast application launcher"
  homepage "https://github.com/wickes1/Komet"

  depends_on macos: :ventura

  app "Komet.app"

  # Homebrew runs these steps in a sandbox that cannot launch an app (`open` fails there), so the cask
  # only clears the quarantine flag; the caveats say how to start Komet.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Komet.app"], must_succeed: false
  end

  # Without this an uninstall deletes the app and leaves it running.
  uninstall quit: "com.wickes1.komet"

  zap trash: [
    "~/Library/Caches/com.wickes1.komet",
    "~/Library/Preferences/com.wickes1.komet.plist",
  ]

  caveats <<~EOS
    Start Komet now:
      open -a Komet

    Komet needs no permissions. Its hotkey is Cmd+Space: turn off Spotlight's
    shortcut in System Settings → Keyboard → Keyboard Shortcuts → Spotlight.

    Komet is unsigned. If blocked by Gatekeeper:
    1. Go to System Settings → Privacy & Security
    2. Click "Open Anyway" next to the Komet warning
  EOS
end
