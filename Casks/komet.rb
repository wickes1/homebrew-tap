cask "komet" do
  version "0.1.6"
  sha256 "dcf99f577d202aec417b3220528921da9696f3bff8e637d72e2930e0f0eb6f3a"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal macOS app launcher"
  homepage "https://github.com/wickes1/Komet"

  app "Komet.app"
end
