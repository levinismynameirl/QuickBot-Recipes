class QuickOpenPlugin < PluginFormula
  name "quick_open"
  version "1.0.0"
  desc "Fuzzy application launcher for macOS"
  homepage "https://github.com/levinismynameirl/quickbot-quick-open"
  url "https://github.com/levinismynameirl/quickbot-quick-open/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "launcher", "utility"

  aliases(
    "qo" => "quick_open",
    "qof" => "quick_open --fuzzy"
  )

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    Aliases registered:
      qo  → quick quick_open
      qof → quick quick_open --fuzzy
  EOS
end
