class EncodeToolPlugin < PluginFormula
  name "encode_tool"
  version "1.0.0"
  desc "Base64 and URL encode/decode"
  homepage "https://github.com/levinismynameirl/quickbot-encode-tool"
  url "https://github.com/levinismynameirl/quickbot-encode-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "encoding", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
