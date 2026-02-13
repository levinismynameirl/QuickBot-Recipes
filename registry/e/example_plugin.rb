# frozen_string_literal: true

# Example Plugin Formula
#
# This formula tells QuickBot how to install the "example_plugin" plugin.
# Note: The URLs below are fictional examples. Replace with your real repo.
#
# Plugin authors: This is a template for your own formula. The actual plugin
# code lives in YOUR repository, not here. This file just describes how to
# install it.
#
# To install: quick install example_plugin

require_relative "../../abstract/formula"

class ExamplePlugin < PluginFormula
  # ─────────────────────────────────────────────────────────────────────────────
  # Required Metadata
  # ─────────────────────────────────────────────────────────────────────────────

  name "example_plugin"
  version "1.0.0"
  desc "Running the installation for this plugin will not work."
  homepage "https://github.com/quickbot/example-plugin"

  # ─────────────────────────────────────────────────────────────────────────────
  # Installation Source
  #
  # The URL points to the plugin author's repository release.
  # When installed, QuickBot will:
  #   1. Download this tarball
  #   2. Verify the SHA256 checksum
  #   3. Extract it to ~/.config/.quickbot/data/plugins/example_plugin/
  # ─────────────────────────────────────────────────────────────────────────────

  url "https://github.com/quickbot/example-plugin/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  # Alternative: Install from git directly (uncomment to use instead of url)
  # git "https://github.com/quickbot/example-plugin.git", tag: "v1.0.0"

  # ─────────────────────────────────────────────────────────────────────────────
  # Optional Metadata
  # ─────────────────────────────────────────────────────────────────────────────

  author "QuickBot Team"
  license "MIT"
  plugin_type :command
  categories "example", "utility", "starter"

  # ─────────────────────────────────────────────────────────────────────────────
  # Version Requirements
  # ─────────────────────────────────────────────────────────────────────────────

  quickbot_version ">= 0.1.0.dev0"
  python_version ">= 3.11"

  # ─────────────────────────────────────────────────────────────────────────────
  # Dependencies
  #
  # Python packages will be installed via pip when the plugin is installed.
  # Plugin dependencies will be installed first if not already present.
  # System dependencies are checked but not auto-installed.
  # ─────────────────────────────────────────────────────────────────────────────

  # depends_on_python "requests >= 2.25.0", "click >= 7.0"
  # depends_on_plugin "another_plugin >= 1.0.0"
  # depends_on_system "git", "curl"

  # ─────────────────────────────────────────────────────────────────────────────
  # Aliases
  #
  # Shortcuts that users can type instead of the full command.
  # These are registered with QuickBot when the plugin is installed.
  # ─────────────────────────────────────────────────────────────────────────────

  aliases(
    "ex" => "example_plugin",           # quick ex -> quick example_plugin
    "exh" => "example_plugin --help",   # quick exh -> quick example_plugin --help
    "exv" => "example_plugin --version" # quick exv -> quick example_plugin --version
  )

  # ─────────────────────────────────────────────────────────────────────────────
  # Hooks (for extension-type plugins)
  #
  # Hooks allow plugins to intercept QuickBot's lifecycle events.
  # The handler path is relative to the installed plugin directory.
  # ─────────────────────────────────────────────────────────────────────────────

  # hooks(
  #   pre_command: "hooks/lifecycle.py:pre_command_handler",
  #   post_command: "hooks/lifecycle.py:post_command_handler"
  # )

  # ─────────────────────────────────────────────────────────────────────────────
  # Caveats
  #
  # Message shown to the user after successful installation.
  # ─────────────────────────────────────────────────────────────────────────────

  caveats <<~EOS
    Example Plugin has been installed!

    Usage:
      quick example_plugin [name]     Greet someone
      quick example_plugin --help     Show help

    Aliases:
      ex  -> example_plugin
      exh -> example_plugin --help
      exv -> example_plugin --version

    For more information, visit:
      https://github.com/quickbot/example-plugin
  EOS
end
