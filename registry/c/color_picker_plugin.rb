class ColorPickerPlugin < PluginFormula
  name "color_picker"
  version "1.0.0"
  desc "Convert between hex, RGB, and HSL color formats"
  homepage "https://github.com/levinismynameirl/quickbot-color-picker"
  url "https://github.com/levinismynameirl/quickbot-color-picker/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "design", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
