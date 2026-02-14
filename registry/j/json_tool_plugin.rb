class JsonToolPlugin < PluginFormula
  name "json_tool"
  version "1.0.0"
  desc "Pretty-print, validate, minify, and query JSON"
  homepage "https://github.com/levinismynameirl/quickbot-json-tool"
  url "https://github.com/levinismynameirl/quickbot-json-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
