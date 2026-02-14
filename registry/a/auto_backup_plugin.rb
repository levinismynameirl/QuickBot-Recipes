class AutoBackupPlugin < PluginFormula
  name "auto_backup"
  version "1.0.0"
  desc "Automatically back up config before QuickBot updates"
  homepage "https://github.com/levinismynameirl/quickbot-auto-backup"
  url "https://github.com/levinismynameirl/quickbot-auto-backup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "backup", "utility"

  hooks(
    pre_update: "hooks.pre_update"
  )

  quickbot_version ">= 0.1.0.dev0"
  max_quickbot_version "0.1.0.dev0"
  python_version ">= 3.11"

  supported_quickbot_versions(
    "0.1.0.dev0" => {
      url: "https://github.com/levinismynameirl/quickbot-auto-backup/archive/refs/tags/v1.0.0.tar.gz",
      sha256: "0000000000000000000000000000000000000000000000000000000000000000",
      version: "1.0.0"
    }
  )

  dev_version "1.1.0.dev0"
  dev_url "https://github.com/levinismynameirl/quickbot-auto-backup/archive/refs/heads/dev.tar.gz"
  dev_sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  caveats <<~EOS
    ⚠ Hook plugin: Automatically backs up config before updates.
    View backups:    quick auto_backup --list
    Manual backup:   quick auto_backup --now
    Restore latest:  quick auto_backup --restore

    This plugin hooks into QuickBot's update lifecycle.
    Check compatibility before updating QuickBot:
      quick update
  EOS
end
