class CommandLoggerPlugin < PluginFormula
  name "command_logger"
  version "1.0.0"
  desc "Log every command execution time and results"
  homepage "https://github.com/levinismynameirl/quickbot-command-logger"
  url "https://github.com/levinismynameirl/quickbot-command-logger/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "logging"

  hooks(
    pre_command: "hooks.pre_command",
    post_command: "hooks.post_command",
    on_error: "hooks.on_error"
  )

  quickbot_version ">= 0.1.0.dev0"
  max_quickbot_version "0.1.0.dev0"
  python_version ">= 3.11"

  supported_quickbot_versions(
    "0.1.0.dev0" => {
      url: "https://github.com/levinismynameirl/quickbot-command-logger/archive/refs/tags/v1.0.0.tar.gz",
      sha256: "0000000000000000000000000000000000000000000000000000000000000000",
      version: "1.0.0"
    }
  )

  dev_version "1.1.0.dev0"
  dev_url "https://github.com/levinismynameirl/quickbot-command-logger/archive/refs/heads/dev.tar.gz"
  dev_sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  caveats <<~EOS
    ⚠ Hook plugin: Logs command execution time and errors.
    View history with: quick command_logger
    Clear logs with:   quick command_logger --clear

    This plugin hooks into QuickBot's command lifecycle.
    Check compatibility before updating QuickBot:
      quick update
  EOS
end
