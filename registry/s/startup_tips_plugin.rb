class StartupTipsPlugin < PluginFormula
  name "startup_tips"
  version "1.0.0"
  desc "Show random QuickBot tips on startup"
  homepage "https://github.com/levinismynameirl/quickbot-startup-tips"
  url "https://github.com/levinismynameirl/quickbot-startup-tips/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "utility", "tips"

  hooks(
    on_startup: "hooks.on_startup"
  )

  quickbot_version ">= 0.1.0.dev0"
  max_quickbot_version "0.1.0.dev0"
  python_version ">= 3.11"

  supported_quickbot_versions(
    "0.1.0.dev0" => {
      url: "https://github.com/levinismynameirl/quickbot-startup-tips/archive/refs/tags/v1.0.0.tar.gz",
      sha256: "0000000000000000000000000000000000000000000000000000000000000000",
      version: "1.0.0"
    }
  )

  caveats <<~EOS
    ⚠ Hook plugin: Shows a random tip when QuickBot starts.
    View all tips: quick startup_tips --all
    Add your own:  quick startup_tips --add "Your tip here"

    This plugin hooks into QuickBot's startup lifecycle.
    Check compatibility before updating QuickBot:
      quick update
  EOS
end
