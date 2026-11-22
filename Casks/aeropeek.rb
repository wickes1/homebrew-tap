# Homebrew cask, filled in by scripts/release.sh (version, sha256, repo). Goes into a tap as Casks/aeropeek.rb.
cask "aeropeek" do
  version "1.0.1"
  sha256 "18619cdce0ade1abe41641615f19e1b1dc790a45c1d51913e05e25de8e7bac80"

  url "https://github.com/wickes1/aeropeek/releases/download/v#{version}/AeroPeek-#{version}.zip"
  name "aeropeek"
  desc "Dock window previews for AeroSpace users"
  homepage "https://github.com/wickes1/aeropeek"

  depends_on macos: :sonoma

  app "AeroPeek.app"

  # AeroPeek.app is self-signed, not notarized: left quarantined, Gatekeeper refuses it. Starting the
  # app from here is not possible: Homebrew runs these steps in a sandbox that cannot reach
  # LaunchServices, hence the caveat.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/AeroPeek.app"], must_succeed: false
  end

  uninstall quit: "dev.wickend.aeropeek"

  caveats <<~EOS
    AeroPeek.app is self-signed, not notarized. This cask cleared its download
    quarantine flag so that it can start.

    aeropeek needs AeroSpace and a Dock at the bottom of the screen.

    Start it now:
      open -a AeroPeek

    Then turn on AeroPeek in System Settings → Privacy & Security, under both
    Accessibility and Screen & System Audio Recording, and start it once more:
      pkill -x AeroPeek; sleep 1; open -a AeroPeek
  EOS
end
