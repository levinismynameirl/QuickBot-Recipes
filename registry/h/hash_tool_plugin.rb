class HashToolPlugin < PluginFormula
  name "hash_tool"
  version "1.0.0"
  desc "Hash strings and files with multiple algorithms"
  homepage "https://github.com/levinismynameirl/quickbot-hash-tool"
  url "https://github.com/levinismynameirl/quickbot-hash-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "security", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
