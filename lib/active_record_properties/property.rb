# frozen_string_literal: true

module ActiveRecordProperties
  # Represents a single property definition
  class Property
    attr_reader :name, :type, :default, :column

    SUPPORTED_TYPES = %i[string integer float boolean hash array].freeze

    def initialize(name, type: :string, default: nil, column: :properties)
      @name = name.to_sym
      @type = type.to_sym
      @default = default
      @column = column.to_sym

      validate_type!
    end

    def default_value
      return default.call if default.respond_to?(:call)
      default
    end

    private

    def validate_type!
      return if SUPPORTED_TYPES.include?(type)

      raise ArgumentError, "Unsupported type: #{type}. " \
                           "Supported types: #{SUPPORTED_TYPES.join(", ")}"
    end
  end
end
