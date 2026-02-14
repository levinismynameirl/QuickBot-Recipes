# frozen_string_literal: true

# QuickBot Plugin Formula Base Class
#
# This is the base class that all plugin formulas in the registry inherit from.
# Formulas are Ruby files that describe HOW to install a plugin - they don't
# contain the actual plugin code.
#
# The actual plugin code lives in the plugin author's own repository.
# When a user runs `quick plugin --install plugin_name`, QuickBot:
#   1. Reads the formula from this registry
#   2. Downloads the plugin from the URL specified in the formula
#   3. Installs it into QuickBot's plugins/ directory
#
# Usage:
#     class MyPlugin < PluginFormula
#       name "my_plugin"
#       version "1.0.0"
#       desc "Description of my plugin"
#       homepage "https://github.com/author/my-plugin"
#       url "https://github.com/author/my-plugin/archive/v1.0.0.tar.gz"
#       sha256 "abc123..."
#     end

# Base class for plugin formulas
class PluginFormula
  class << self
    # ─────────────────────────────────────────────────────────────────────────
    # Required Metadata
    # ─────────────────────────────────────────────────────────────────────────

    # Plugin name (unique identifier)
    def name(value = nil)
      @name = value if value
      @name
    end

    # Plugin version (semantic versioning)
    def version(value = nil)
      @version = value if value
      @version
    end

    # Short description
    def desc(value = nil)
      @desc = value if value
      @desc
    end

    # Plugin homepage URL
    def homepage(value = nil)
      @homepage = value if value
      @homepage
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Installation Source
    # ─────────────────────────────────────────────────────────────────────────

    # Download URL (tarball or zip)
    def url(value = nil)
      @url = value if value
      @url
    end

    # SHA256 checksum of the download
    def sha256(value = nil)
      @sha256 = value if value
      @sha256
    end

    # Git repository URL (alternative to url)
    def git(url = nil, **options)
      if url
        @git_url = url
        @git_branch = options[:branch]
        @git_tag = options[:tag]
        @git_revision = options[:revision]
      end
      { url: @git_url, branch: @git_branch, tag: @git_tag, revision: @git_revision }
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Optional Metadata
    # ─────────────────────────────────────────────────────────────────────────

    # Plugin author
    def author(value = nil)
      @author = value if value
      @author
    end

    # License identifier
    def license(value = nil)
      @license = value if value
      @license
    end

    # Plugin type (:command, :extension, :library)
    def plugin_type(value = nil)
      @plugin_type = value if value
      @plugin_type || :command
    end

    # Categories for discovery
    def categories(*values)
      @categories = values.flatten if values.any?
      @categories || []
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Dependencies
    # ─────────────────────────────────────────────────────────────────────────

    # Python dependencies (pip packages)
    def depends_on_python(*packages)
      @python_deps ||= []
      @python_deps.concat(packages.flatten)
      @python_deps
    end

    # Other QuickBot plugins this depends on
    def depends_on_plugin(*plugins)
      @plugin_deps ||= []
      @plugin_deps.concat(plugins.flatten)
      @plugin_deps
    end

    # System tools required
    def depends_on_system(*tools)
      @system_deps ||= []
      @system_deps.concat(tools.flatten)
      @system_deps
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Aliases
    # ─────────────────────────────────────────────────────────────────────────

    # Define aliases for this plugin's commands
    def aliases(mapping = nil)
      @aliases = mapping if mapping
      @aliases || {}
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Hooks
    # ─────────────────────────────────────────────────────────────────────────

    # Define hooks this plugin registers
    def hooks(mapping = nil)
      @hooks = mapping if mapping
      @hooks || {}
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Conflicts
    # ─────────────────────────────────────────────────────────────────────────

    # Declare conflicts with other plugins or builtin commands
    def conflicts_with(*names)
      @conflicts ||= []
      @conflicts.concat(names.flatten)
      @conflicts
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Version Requirements
    # ─────────────────────────────────────────────────────────────────────────

    # Minimum QuickBot version
    def quickbot_version(value = nil)
      @quickbot_version = value if value
      @quickbot_version
    end

    # Maximum QuickBot version tested/supported (for hook plugins)
    def max_quickbot_version(value = nil)
      @max_quickbot_version = value if value
      @max_quickbot_version
    end

    # Minimum Python version
    def python_version(value = nil)
      @python_version = value if value
      @python_version
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Version-Specific Releases (Hook Plugins)
    # ─────────────────────────────────────────────────────────────────────────

    # Map QuickBot versions to specific plugin releases
    # Used by hook plugins that need tight version coupling
    #
    # Example:
    #   supported_quickbot_versions(
    #     "0.1.0" => { url: "...", sha256: "...", version: "1.0.0" },
    #     "0.2.0" => { url: "...", sha256: "...", version: "2.0.0" }
    #   )
    def supported_quickbot_versions(mapping = nil)
      @supported_quickbot_versions = mapping if mapping
      @supported_quickbot_versions || {}
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Development Builds
    # ─────────────────────────────────────────────────────────────────────────

    # Dev version of the plugin
    def dev_version(value = nil)
      @dev_version = value if value
      @dev_version
    end

    # Dev download URL
    def dev_url(value = nil)
      @dev_url = value if value
      @dev_url
    end

    # Dev SHA256
    def dev_sha256(value = nil)
      @dev_sha256 = value if value
      @dev_sha256
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Post-Install
    # ─────────────────────────────────────────────────────────────────────────

    # Caveats message shown after installation
    def caveats(value = nil, &block)
      @caveats = value || block if value || block
      @caveats
    end

    # ─────────────────────────────────────────────────────────────────────────
    # Validation
    # ─────────────────────────────────────────────────────────────────────────

    def validate!
      errors = []
      errors << "name is required" unless name
      errors << "version is required" unless version
      errors << "desc is required" unless desc
      errors << "homepage is required" unless homepage
      errors << "url or git is required" unless url || @git_url
      errors << "sha256 is required when using url" if url && !sha256

      raise "Formula validation failed: #{errors.join(', ')}" if errors.any?

      true
    end

    # Convert to hash for serialization
    def to_h
      {
        name: name,
        version: version,
        desc: desc,
        homepage: homepage,
        url: url,
        sha256: sha256,
        git: git,
        author: author,
        license: license,
        plugin_type: plugin_type,
        categories: categories,
        python_deps: @python_deps || [],
        plugin_deps: @plugin_deps || [],
        system_deps: @system_deps || [],
        aliases: aliases,
        hooks: hooks,
        quickbot_version: quickbot_version,
        python_version: python_version,
        conflicts: @conflicts || [],
        max_quickbot_version: @max_quickbot_version,
        supported_quickbot_versions: @supported_quickbot_versions || {},
        dev_version: @dev_version,
        dev_url: @dev_url,
        dev_sha256: @dev_sha256
      }
    end
  end
end
