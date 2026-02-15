class ProjectInitPlugin < PluginFormula
  name "project_init"
  version "1.0.0"
  desc "Scaffold new projects from templates"
  homepage "https://github.com/levinismynameirl/quickbot-project-init"
  url "https://github.com/levinismynameirl/quickbot-project-init/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "development", "scaffolding"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  caveats <<~EOS
    Create projects with:
      quick project_init python myapp
      quick project_init node myapp
      quick project_init web mysite
  EOS
end
