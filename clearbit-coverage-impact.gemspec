# frozen_string_literal: true

require_relative "lib/clearbit/coverage_impact/version"

Gem::Specification.new do |spec|
  spec.name          = "clearbit-coverage-impact"
  spec.version       = Clearbit::CoverageImpact::VERSION
  spec.authors       = ["Micah Bowie"]
  spec.email         = ["micah.bowie@clearbit.com"]

  spec.summary       = "Write a short summary, because RubyGems requires one."
  spec.description   = "Write a longer description or delete this line."
  spec.homepage      = 'https://github.com/clearbit/clearbit-coverage-impact'
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~> 5.0', '>= 5.0'
  spec.add_dependency 'colorize', '~> 0.8.1'
  spec.add_dependency 'hashie', '~> 5.0'
  spec.add_dependency 'shale', '~> 0.9.0'
  spec.add_dependency 'terminal-table', '~> 3.0', '>= 3.0.2'

  spec.add_development_dependency 'byebug'
end
