cask "komet" do
  version "0.1.3"
  sha256 "3d64344db310870669e771de0595cb89932a214fd5ea08195943619011f866f7"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal macOS app launcher"
  homepage "https://github.com/wickes1/Komet"

  app "Komet.app"
end
