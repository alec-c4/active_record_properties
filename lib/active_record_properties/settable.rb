# frozen_string_literal: true

require "active_support/concern"

module ActiveRecordProperties
  # Main concern for adding properties to ActiveRecord models
  module Settable
    extend ActiveSupport::Concern

    class_methods do
      # Define properties stored in JSONB column
      #
      # @param column [Symbol] Name of JSONB column (default: :properties)
      # @param block [Proc] Block with property definitions
      #
      # @example
      #   class Organization < ApplicationRecord
      #     include ActiveRecordProperties::Settable
      #
      #     has_properties column: :settings do
      #       property :income_tax_rate, type: :float, default: 13.0
      #       property :auto_calculate_net_salary, type: :boolean, default: true
      #       property :probation_period_months, type: :integer, default: 3
      #       property :notification_settings, type: :hash, default: -> { {} }
      #     end
      #   end
      #
      #   org = Organization.new
      #   org.income_tax_rate # => 13.0
      #   org.income_tax_rate = 15.0
      def has_properties(column: :properties, &block)
        dsl = DSL.new(column)
        dsl.instance_eval(&block)

        setup_properties(column, dsl.properties)
      end

      private

      def setup_properties(column, properties)
        # Setup store_accessor for JSONB column
        accessor_names = properties.map(&:name)
        store_accessor column, *accessor_names

        # Store properties metadata for introspection
        class_variable_set(:@@_properties, properties)
        class_variable_set(:@@_properties_column, column)

        # Initialize defaults via callback
        after_initialize do
          column_data = send(column) || {}

          properties.each do |property|
            # Only set default if value is not already set
            next if column_data.key?(property.name.to_s)

            default_val = property.default_value
            send("#{property.name}=", default_val) unless default_val.nil?
          end
        end
      end
    end

    # Get all defined properties
    #
    # @return [Array<Property>] Array of property definitions
    def self.properties
      return [] unless class_variable_defined?(:@@_properties)

      class_variable_get(:@@_properties)
    end

    # Get properties column name
    #
    # @return [Symbol] Column name
    def self.properties_column
      return :properties unless class_variable_defined?(:@@_properties_column)

      class_variable_get(:@@_properties_column)
    end
  end
end
