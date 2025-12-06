cask "komet" do
  version "0.1.4"
  sha256 "4544f083627edd1c3ea411e536ad7842fd6f0a1992160f563535728fe65571ee"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal macOS app launcher"
  homepage "https://github.com/wickes1/Komet"

  app "Komet.app"
end
