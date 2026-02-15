class DiskUsagePlugin < PluginFormula
  name "disk_usage"
  version "1.0.0"
  desc "Analyze and visualize disk usage"
  homepage "https://github.com/levinismynameirl/quickbot-disk-usage"
  url "https://github.com/levinismynameirl/quickbot-disk-usage/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "system", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
