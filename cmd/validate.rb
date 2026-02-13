#!/usr/bin/env ruby
# frozen_string_literal: true

# Formula Validation Script
#
# Validates plugin formulas for syntax and required fields.
#
# Usage:
#   ruby cmd/validate.rb registry/e/example_plugin.rb
#   ruby cmd/validate.rb --all

require_relative "../abstract/formula"

def validate_formula(path)
  puts "Validating: #{path}"
  
  begin
    # Check syntax
    result = system("ruby", "-c", path, out: File::NULL, err: File::NULL)
    unless result
      puts "  ✗ Syntax error"
      return false
    end
    
    # Load the formula
    load path
    
    # Find the formula class (last defined class that inherits from PluginFormula)
    formula_class = ObjectSpace.each_object(Class).find do |klass|
      klass < PluginFormula && klass != PluginFormula
    end
    
    unless formula_class
      puts "  ✗ No PluginFormula subclass found"
      return false
    end
    
    # Validate required fields
    errors = []
    errors << "name is required" unless formula_class.name
    errors << "version is required" unless formula_class.version
    errors << "desc is required" unless formula_class.desc
    errors << "homepage is required" unless formula_class.homepage
    
    has_url = formula_class.url && !formula_class.url.empty?
    has_git = formula_class.git[:url] && !formula_class.git[:url].empty?
    
    errors << "url or git is required" unless has_url || has_git
    
    if has_url && (!formula_class.sha256 || formula_class.sha256.empty?)
      errors << "sha256 is required when using url"
    end
    
    if errors.any?
      errors.each { |e| puts "  ✗ #{e}" }
      return false
    end
    
    puts "  ✓ Valid"
    true
    
  rescue StandardError => e
    puts "  ✗ Error: #{e.message}"
    false
  end
end

def validate_all
  formulas = Dir["registry/*/*.rb"]
  
  valid = 0
  invalid = 0
  
  formulas.each do |path|
    if validate_formula(path)
      valid += 1
    else
      invalid += 1
    end
  end
  
  puts "\nResults: #{valid} valid, #{invalid} invalid"
  exit(invalid.zero? ? 0 : 1)
end

# Main
if ARGV.include?("--all")
  validate_all
elsif ARGV.empty?
  puts "Usage: ruby cmd/validate.rb <formula.rb>"
  puts "       ruby cmd/validate.rb --all"
  exit 1
else
  success = ARGV.all? { |path| validate_formula(path) }
  exit(success ? 0 : 1)
end
