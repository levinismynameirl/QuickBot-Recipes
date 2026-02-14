class GitStatsPlugin < PluginFormula
  name "git_stats"
  version "1.0.0"
  desc "Show git repository statistics"
  homepage "https://github.com/levinismynameirl/quickbot-git-stats"
  url "https://github.com/levinismynameirl/quickbot-git-stats/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "git"

  depends_on_system "git"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
