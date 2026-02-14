class QuickOpenAltPlugin < PluginFormula
  name "quick_open_alt"
  version "1.0.0"
  desc "Alternative app launcher with recent apps focus"
  homepage "https://github.com/levinismynameirl/quickbot-quick-open-alt"
  url "https://github.com/levinismynameirl/quickbot-quick-open-alt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "launcher", "utility"

  aliases(
    "qo" => "quick_open_alt"
  )

  conflicts_with "quick_open"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    ⚠ This plugin CONFLICTS with quick_open (both use alias "qo").
    Only one can be installed at a time.
  EOS
end
