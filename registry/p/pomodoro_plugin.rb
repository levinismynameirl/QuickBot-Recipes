class PomodoroPlugin < PluginFormula
  name "pomodoro"
  version "1.0.0"
  desc "Pomodoro focus timer with macOS notifications"
  homepage "https://github.com/levinismynameirl/quickbot-pomodoro"
  url "https://github.com/levinismynameirl/quickbot-pomodoro/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "productivity", "timer"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    Start a 25-minute focus session with:
      quick pomodoro
    Customize with --break, --long-break, or --duration N
  EOS
end
