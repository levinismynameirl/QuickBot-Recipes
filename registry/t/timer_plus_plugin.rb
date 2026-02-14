class TimerPlusPlugin < PluginFormula
  name "timer_plus"
  version "1.0.0"
  desc "Enhanced timer with intervals and stopwatch"
  homepage "https://github.com/levinismynameirl/quickbot-timer-plus"
  url "https://github.com/levinismynameirl/quickbot-timer-plus/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "timer", "utility"

  aliases(
    "tp" => "timer_plus"
  )

  conflicts_with "timer"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    ⚠ This plugin conflicts with the built-in 'timer' command.
    It cannot be installed alongside QuickBot's native timer.
    Use the alias 'tp' instead: quick tp 5m
  EOS
end
