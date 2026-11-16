# Homebrew cask, filled in by scripts/release.sh (version, sha256, repo). Goes into a tap as Casks/beckon.rb.
cask "beckon" do
  version "0.2.0"
  sha256 "d004426c21ec08e0d85776b9ec707f32291567ef7b4b92fd501313d8ba346ee8"

  url "https://github.com/wickes1/beckon/releases/download/v#{version}/Beckon-#{version}.zip"
  name "beckon"
  desc "Floating panel that answers Claude Code prompts and jumps to the terminal"
  homepage "https://github.com/wickes1/beckon"

  depends_on macos: :sonoma

  app "Beckon.app"
  binary "#{appdir}/Beckon.app/Contents/MacOS/beckon"

  # Beckon.app is self-signed, not notarized: left quarantined, Gatekeeper refuses both the app and the hook
  # CLI inside it. Starting the app from here is not possible: Homebrew runs these steps in a sandbox that
  # cannot reach LaunchServices (`open` fails with kLSNoExecutableErr), hence the caveat.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Beckon.app"], must_succeed: false
  end

  uninstall quit: "dev.wickend.beckon"

  zap trash: [
    "~/Library/Application Support/beckon",
    "~/Library/Logs/beckon.log",
  ]

  caveats <<~EOS
    Beckon.app is self-signed, not notarized. This cask cleared its download
    quarantine flag so that it can start.

    Start it now, and again after every upgrade (an upgrade quits it):
      open -a Beckon
    Menu bar ✳ → Open at Login starts it with the Mac.

    Wire beckon into Claude Code with its plugin, then check the setup:
      claude plugin marketplace add wickes1/beckon
      claude plugin install beckon@beckon
      beckon doctor

    VS Code: install the bundled extension once per profile, so that a click
    lands on the exact window and terminal:
      code --install-extension "#{appdir}/Beckon.app/Contents/Resources/beckon.vsix"
  EOS
end
