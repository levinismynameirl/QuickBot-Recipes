class SnippetManagerPlugin < PluginFormula
  name "snippet_manager"
  version "1.0.0"
  desc "Store and retrieve code snippets"
  homepage "https://github.com/levinismynameirl/quickbot-snippet-manager"
  url "https://github.com/levinismynameirl/quickbot-snippet-manager/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "productivity"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
