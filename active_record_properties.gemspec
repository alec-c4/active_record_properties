# frozen_string_literal: true

require_relative "lib/active_record_properties/version"

Gem::Specification.new do |spec|
  spec.name = "active_record_properties"
  spec.version = ActiveRecordProperties::VERSION
  spec.authors = ["Alexey Poimtsev"]
  spec.email = ["alexey.poimtsev@gmail.com"]

  spec.summary = "Type-safe properties stored in JSONB for ActiveRecord models"
  spec.description = "Store model settings and properties in JSONB columns with a clean DSL, " \
                     "type casting, default values, and validations. " \
                     "A modern alternative to separate settings tables."
  spec.homepage = "https://github.com/alec-c4/active_record_properties"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/alec-c4/active_record_properties"
  spec.metadata["changelog_uri"] = "https://github.com/alec-c4/active_record_properties/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir.chdir(__dir__) do
    Dir["{lib}/**/*", "LICENSE.txt", "README.md", "CHANGELOG.md"].reject { |f| File.directory?(f) }
  end
  spec.bindir = "exe"
  spec.executables = []
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 7.2"
  spec.add_dependency "activesupport", ">= 7.2"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.21"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "lefthook"
  spec.add_development_dependency "sqlite3", "~> 2.0"
  spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "standard", ">= 1.35.1"
end
