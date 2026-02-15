class TodoManagerPlugin < PluginFormula
  name "todo_manager"
  version "1.0.0"
  desc "Simple file-based todo list manager"
  homepage "https://github.com/levinismynameirl/quickbot-todo-manager"
  url "https://github.com/levinismynameirl/quickbot-todo-manager/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "productivity", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    Manage todos with subcommands:
      quick todo_manager add "Task description"
      quick todo_manager done 1
      quick todo_manager clear
  EOS
end
