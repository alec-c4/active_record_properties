# frozen_string_literal: true

module ActiveRecordProperties
  # DSL for defining properties
  class DSL
    attr_reader :properties, :column

    def initialize(column)
      @column = column
      @properties = []
    end

    # Define a property
    #
    # @param name [Symbol, String] Property name
    # @param type [Symbol] Property type (:string, :integer, :float, :boolean, :hash, :array)
    # @param default [Object, Proc] Default value or proc
    #
    # @example
    #   property :income_tax_rate, type: :float, default: 13.0
    #   property :settings, type: :hash, default: -> { {} }
    def property(name, type: :string, default: nil)
      prop = Property.new(name, type: type, default: default, column: column)
      @properties << prop
    end
  end
end
