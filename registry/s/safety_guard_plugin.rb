class SafetyGuardPlugin < PluginFormula
  name "safety_guard"
  version "1.0.0"
  desc "Block dangerous commands without --force confirmation"
  homepage "https://github.com/levinismynameirl/quickbot-safety-guard"
  url "https://github.com/levinismynameirl/quickbot-safety-guard/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "safety", "utility"

  hooks(
    pre_command: "hooks.pre_command"
  )

  quickbot_version ">= 0.1.0.dev0"
  max_quickbot_version "0.1.0.dev0"
  python_version ">= 3.11"

  supported_quickbot_versions(
    "0.1.0.dev0" => {
      url: "https://github.com/levinismynameirl/quickbot-safety-guard/archive/refs/tags/v1.0.0.tar.gz",
      sha256: "0000000000000000000000000000000000000000000000000000000000000000",
      version: "1.0.0"
    }
  )

  dev_version "1.1.0.dev0"
  dev_url "https://github.com/levinismynameirl/quickbot-safety-guard/archive/refs/heads/dev.tar.gz"
  dev_sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  caveats <<~EOS
    ⚠ Hook plugin: Blocks clean, trash, kill, eject without --force.
    Configure with: quick safety_guard
    Disable with:   quick safety_guard --disable

    This plugin intercepts commands before execution.
    Check compatibility before updating QuickBot:
      quick update
  EOS
end
