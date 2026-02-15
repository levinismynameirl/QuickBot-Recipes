class BookmarkManagerPlugin < PluginFormula
  name "bookmark_manager"
  version "1.0.0"
  desc "URL bookmark manager with tags"
  homepage "https://github.com/levinismynameirl/quickbot-bookmark-manager"
  url "https://github.com/levinismynameirl/quickbot-bookmark-manager/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "productivity", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
