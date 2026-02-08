# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/bin/"
end

require "active_record"
require "active_record_properties"

# Setup in-memory SQLite database for tests
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

# Load schema
ActiveRecord::Schema.define do
  create_table :test_models, force: true do |t|
    if ActiveRecord::Base.connection.adapter_name == "SQLite" && ActiveRecord::VERSION::STRING >= "7.1"
      t.json :properties
      t.json :settings
    else
      t.text :properties
      t.text :settings
    end
    t.timestamps
  end
end

# Define test model with JSON serialization for SQLite
class TestModel < ActiveRecord::Base
  if ActiveRecord::Base.connection.adapter_name == "SQLite" && ActiveRecord::VERSION::STRING < "7.1"
    serialize :properties, coder: JSON
    serialize :settings, coder: JSON
  end

  include ActiveRecordProperties::Settable

  has_properties column: :properties do
    property :name, type: :string, default: "default"
    property :count, type: :integer, default: 0
    property :rate, type: :float, default: 1.5
    property :enabled, type: :boolean, default: true
    property :config, type: :hash, default: -> { {} }
    property :tags, type: :array, default: -> { [] }
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Clean database before each test
  config.before do
    TestModel.delete_all
  end
end
