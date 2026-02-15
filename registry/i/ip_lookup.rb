class IpLookupPlugin < PluginFormula
  name "ip_lookup"
  version "1.0.0"
  desc "Show public and local IP addresses with geolocation"
  homepage "https://github.com/levinismynameirl/quickbot-ip-lookup"
  url "https://github.com/levinismynameirl/quickbot-ip-lookup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  author "levinismynameirl"
  license "MIT"
  plugin_type :command
  categories "networking", "utility"

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"
end
