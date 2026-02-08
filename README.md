# ActiveRecordProperties

Type-safe properties stored in JSONB for ActiveRecord models. A modern, lightweight alternative to separate settings tables.

## Why ActiveRecordProperties?

Store model settings and properties in a JSONB column with:

- **Clean DSL** - Simple, readable property definitions
- **Type Safety** - Built-in type casting for common types
- **Default Values** - Static or dynamic (proc) defaults
- **Performance** - No JOINs, everything in one table
- **Flexibility** - Use any JSONB column name
- **Rails-native** - Built on `store_accessor` and `attribute` APIs

## Installation

Add to your Gemfile:

```ruby
gem "active_record_properties"
```

Then run:

```bash
bundle install
```

## Quick Start

### 1. Add JSONB column to your model

```ruby
class AddPropertiesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :properties, :jsonb, default: {}, null: false
  end
end
```

### 2. Include the module and define properties

```ruby
class User < ApplicationRecord
  include ActiveRecordProperties::Settable

  has_properties do  # Uses :properties column by default
    property :theme, type: :string, default: "light"
    property :language, type: :string, default: "en"
    property :notifications_enabled, type: :boolean, default: true
    property :email_frequency, type: :string, default: "daily"
    property :preferences, type: :hash, default: -> { {} }
  end
end
```

### 3. Use like normal attributes

```ruby
user = User.new
user.theme                   # => "light"
user.theme = "dark"
user.notifications_enabled   # => true
user.preferences             # => {}
user.save!

# All stored in JSONB
user.properties
# => {"theme"=>"dark", "language"=>"en", "notifications_enabled"=>true, ...}
```

## Usage

### Supported Types

```ruby
has_properties do
  property :name, type: :string, default: "default"
  property :count, type: :integer, default: 0
  property :rate, type: :float, default: 1.5
  property :enabled, type: :boolean, default: true
  property :config, type: :hash, default: -> { {} }
  property :tags, type: :array, default: -> { [] }
end
```

### Static vs Dynamic Defaults

**Static defaults** (for immutable values):

```ruby
property :tax_rate, type: :float, default: 13.0
property :enabled, type: :boolean, default: true
```

**Dynamic defaults** (for mutable values - use proc):

```ruby
property :settings, type: :hash, default: -> { {} }
property :tags, type: :array, default: -> { [] }
```

⚠️ **Important**: Always use proc for Hash and Array defaults to avoid sharing the same object between instances!

### Custom Column Name

By default, `has_properties` uses the `:properties` column. You can specify a different column name:

```ruby
has_properties column: :settings do
  property :foo, type: :string
end

# Defaults to :properties if column is not specified
has_properties do
  property :bar, type: :string
end
```

### Multiple Property Groups

You can use multiple JSONB columns for different purposes:

```ruby
class Organization < ApplicationRecord
  include ActiveRecordProperties::Settable

  has_properties column: :settings do
    property :income_tax_rate, type: :float, default: 13.0
  end

  has_properties column: :preferences do
    property :theme, type: :string, default: "light"
  end
end
```

## Querying

Use PostgreSQL JSONB operators:

```ruby
# Find organizations with specific tax rate
Organization.where("settings->>'income_tax_rate' = ?", "13.0")

# Find organizations with auto-calculation enabled
Organization.where("settings->>'auto_calculate_net_salary' = ?", "true")

# Use JSONB containment
Organization.where("settings @> ?", {enabled: true}.to_json)
```

## Examples

### User Preferences

```ruby
class User < ApplicationRecord
  include ActiveRecordProperties::Settable

  has_properties do  # Uses :properties column by default
    property :theme, type: :string, default: "light"
    property :language, type: :string, default: "en"
    property :notifications_enabled, type: :boolean, default: true
    property :email_frequency, type: :string, default: "daily"
    property :timezone, type: :string, default: "UTC"
    property :ui_preferences, type: :hash, default: -> { {} }
  end

  def notification_time
    Time.current.in_time_zone(timezone)
  end
end

# Usage
user = User.create(theme: "dark", language: "ru")
user.theme              # => "dark"
user.timezone = "Europe/Moscow"
user.notification_time  # => Time in Moscow timezone
```

### Organization Settings

```ruby
class Organization < ApplicationRecord
  include ActiveRecordProperties::Settable

  has_properties column: :settings do
    property :income_tax_rate, type: :float, default: 13.0
    property :auto_calculate_net_salary, type: :boolean, default: true
    property :requires_manager_approval, type: :boolean, default: true
    property :requires_hrd_approval, type: :boolean, default: true
    property :probation_period_months, type: :integer, default: 3
    property :dashboard_period, type: :integer, default: 30
    property :notification_settings, type: :hash, default: -> { {} }
    property :kpi_targets, type: :hash, default: -> { {} }
  end

  def calculate_net_from_gross(gross_amount)
    return nil unless gross_amount && auto_calculate_net_salary

    tax_multiplier = (100 - income_tax_rate) / 100.0
    (gross_amount * tax_multiplier).round(2)
  end
end

# Usage
org = Organization.create(income_tax_rate: 15.0)
org.calculate_net_from_gross(100_000)  # => 85000.0
```

## Comparison with Alternatives

| Feature     | ActiveRecordProperties | rails-settings-cached | ledermann/rails-settings |
| ----------- | ---------------------- | --------------------- | ------------------------ |
| Storage     | JSONB column           | Separate table        | Separate table           |
| Performance | Fast (no JOIN)         | Slower (JOIN)         | Slower (JOIN)            |
| Setup       | Include module         | Global model          | Polymorphic model        |
| API         | `org.setting`          | `Setting.foo`         | `org.settings(:key).foo` |
| Per-model   | ✅ Yes                 | ❌ No (global)        | ✅ Yes                   |
| Type safety | ✅ Yes                 | ✅ Yes                | ⚠️ Limited               |
| Defaults    | ✅ Static + Dynamic    | ✅ Yes                | ✅ Yes                   |

## Rails Compatibility

Tested with:

- Rails 7.0
- Rails 7.1
- Rails 7.2
- Rails 8.0
- Rails 8.1

Ruby 3.2+ required.

## Development

After checking out the repo:

```bash
bin/setup              # Install dependencies
rake spec              # Run tests
bin/console            # Interactive prompt
bundle exec appraisal install  # Install for all Rails versions
bundle exec appraisal rake spec # Test all Rails versions
```

### Running Tests

```bash
rake spec                          # Run all tests
bundle exec appraisal rake spec    # Test against all Rails versions
bundle exec lefthook install       # Install git hooks
```

### Code Quality

```bash
bundle exec rubocop               # Check code style
bundle exec rubocop -A            # Auto-fix issues
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/alec-c4/active_record_properties.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
