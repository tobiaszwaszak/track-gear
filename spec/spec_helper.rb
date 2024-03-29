require "bundler/setup"
Bundler.require

Dir["./*.rb"].each { |file| require file }
Dir["./app/**/*.rb"].each { |file| require file }

Dotenv.load(".env.test")

require "simplecov"
SimpleCov.start

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:deletion)
  rescue ActiveRecord::ConnectionNotEstablished
    next
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  rescue ActiveRecord::ConnectionNotEstablished
    next
  end

  config.after(:all) do
    ActiveRecord::Base.remove_connection
  end
end

