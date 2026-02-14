class CalcPlugin < PluginFormula
  name "calc"
  version "1.0.0"
  desc "Quick math calculator from the command line"
  homepage "https://github.com/levinismynameirl/quickbot-calc"
  url "https://github.com/levinismynameirl/quickbot-calc/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "math", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
