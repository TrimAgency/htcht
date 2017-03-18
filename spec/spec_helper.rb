require 'trimtool'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.allow_message_expectations_on_nil = true
    mocks.syntax = [:should, :expect]
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
