class UuidGenPlugin < PluginFormula
  name "uuid_gen"
  version "1.0.0"
  desc "Generate UUID v4 identifiers"
  homepage "https://github.com/levinismynameirl/quickbot-uuid-gen"
  url "https://github.com/levinismynameirl/quickbot-uuid-gen/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
