cask "komet" do
  version "0.1.5"
  sha256 "04d775731133030e9279fd7613cf2c03e9540eacdd2dd8e012b98cbc4b143084"

  url "https://github.com/wickes1/Komet/releases/download/v#{version}/Komet.dmg"
  name "Komet"
  desc "Minimal macOS app launcher"
  homepage "https://github.com/wickes1/Komet"

  app "Komet.app"
end
