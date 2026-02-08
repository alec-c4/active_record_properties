# frozen_string_literal: true

require_relative "active_record_properties/version"
require_relative "active_record_properties/property"
require_relative "active_record_properties/dsl"
require_relative "active_record_properties/settable"

module ActiveRecordProperties
  class Error < StandardError; end
end
