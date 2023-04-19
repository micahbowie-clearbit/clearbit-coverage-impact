# frozen_string_literal: true

require 'clearbit/impact'
require 'clearbit/coverage_impact/data_store'
require 'clearbit/coverage_impact/analyze'
require 'clearbit/coverage_impact/query'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
