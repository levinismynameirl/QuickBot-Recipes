# frozen_string_literal: true

# QuickBot-Recipes Global Aliases
#
# This file defines global aliases that are always available,
# regardless of which plugins are installed.
#
# Plugin-specific aliases should be defined in the plugin's formula.

GLOBAL_ALIASES = {
  # Plugin management shortcuts
  "qpi" => "quick plugin --install",
  "qpr" => "quick plugin --remove",
  "qpu" => "quick plugin --update",
  "qpl" => "quick plugin --list",
  "qps" => "quick plugin --search",
  
  # Help shortcuts
  "qh" => "quick --help",
  "qv" => "quick --version"
}.freeze
