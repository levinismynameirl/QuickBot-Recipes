class LoremPlugin < PluginFormula
  name "lorem"
  version "1.0.0"
  desc "Generate lorem ipsum placeholder text"
  homepage "https://github.com/levinismynameirl/quickbot-lorem"
  url "https://github.com/levinismynameirl/quickbot-lorem/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "text", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
