cask "komet" do
  version "0.1.2"
  sha256 "79eec6fd41b67ab98b6373368ab168a7ca69522a8d60539309a2bea97f9aed43"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal macOS app launcher"
  homepage "https://github.com/wickes1/Komet"

  app "Komet.app"
end
