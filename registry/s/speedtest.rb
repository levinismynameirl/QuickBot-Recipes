class SpeedtestPlugin < PluginFormula
  name "speedtest"
  version "1.0.0"
  desc "Quick network download speed test"
  homepage "https://github.com/levinismynameirl/quickbot-speedtest"
  url "https://github.com/levinismynameirl/quickbot-speedtest/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "networking", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
