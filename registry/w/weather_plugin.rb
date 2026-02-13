# frozen_string_literal: true

require_relative "../../abstract/formula"

class WeatherPlugin < PluginFormula
  name "weather_plugin"
  version "1.0.0"
  desc "Get current weather for any city with QuickBot"
  homepage "https://github.com/levinismynameirl/weather-plugin"
  url "https://github.com/levinismynameirl/weather-plugin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3b8e93daec1805a9c95bafb9adff8317bf1042c0d9f12aa86c8800b7fa527efa"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "utility", "weather"

  quickbot_version ">= 0.1.0d"
  python_version ">= 3.11"
  depends_on_python "requests >= 2.25.0"

  aliases(
    "w" => "weather_plugin",
    "wt" => "weather_plugin --help"
  )

  caveats <<~EOS
    Plugin installed! Run: quick weather_plugin --help
  EOS
end