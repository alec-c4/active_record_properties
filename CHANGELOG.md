# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-02-08

### Changed
- **BREAKING**: Dropped support for Rails 7.0 and 7.1. Minimum supported Rails version is now 7.2.
- Updated dependencies to support Rails 8.0 and 8.1.
- Improved test configuration for SQLite with JSON columns.

## [0.1.0] - 2026-02-08

### Added
- Initial release
- `ActiveRecordProperties::Settable` concern for adding properties to ActiveRecord models
- `has_properties` DSL for defining properties stored in JSONB columns
- Support for types: string, integer, float, boolean, hash, array
- Static and dynamic (proc) default values
- Automatic initialization of defaults via `after_initialize` callback
- Full test coverage with RSpec (28 examples, 0 failures)
- Support for Rails 7.0+, 7.1+, 7.2+, 8.0+, 8.1+
- Appraisal configuration for testing against multiple Rails versions
- Lefthook configuration for pre-commit hooks (rubocop, rspec, appraisal)
- Comprehensive README with usage examples and comparison table
