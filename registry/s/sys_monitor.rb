class SysMonitorPlugin < PluginFormula
  name "sys_monitor"
  version "1.0.0"
  desc "System monitoring dashboard for macOS"
  homepage "https://github.com/levinismynameirl/quickbot-sys-monitor"
  url "https://github.com/levinismynameirl/quickbot-sys-monitor/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "system", "monitoring"

  aliases(
    "mon" => "sys_monitor",
    "sysm" => "sys_monitor"
  )

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    Aliases registered:
      mon  → quick sys_monitor
      sysm → quick sys_monitor
  EOS
end
