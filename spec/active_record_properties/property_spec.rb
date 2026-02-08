# frozen_string_literal: true

RSpec.describe ActiveRecordProperties::Property do
  describe "#initialize" do
    it "creates property with name" do
      property = described_class.new(:test_name)
      expect(property.name).to eq(:test_name)
    end

    it "creates property with type" do
      property = described_class.new(:test, type: :integer)
      expect(property.type).to eq(:integer)
    end

    it "creates property with default" do
      property = described_class.new(:test, default: 42)
      expect(property.default).to eq(42)
    end

    it "creates property with column" do
      property = described_class.new(:test, column: :settings)
      expect(property.column).to eq(:settings)
    end

    it "defaults to string type" do
      property = described_class.new(:test)
      expect(property.type).to eq(:string)
    end

    it "defaults to properties column" do
      property = described_class.new(:test)
      expect(property.column).to eq(:properties)
    end

    it "raises error for unsupported type" do
      expect {
        described_class.new(:test, type: :unsupported)
      }.to raise_error(ArgumentError, /Unsupported type/)
    end
  end

  describe "#default_value" do
    it "returns static default" do
      property = described_class.new(:test, default: "value")
      expect(property.default_value).to eq("value")
    end

    it "calls proc default" do
      property = described_class.new(:test, default: -> { "dynamic" })
      expect(property.default_value).to eq("dynamic")
    end

    it "returns nil when no default" do
      property = described_class.new(:test)
      expect(property.default_value).to be_nil
    end
  end

  describe "SUPPORTED_TYPES" do
    it "includes basic types" do
      expect(described_class::SUPPORTED_TYPES).to include(
        :string, :integer, :float, :boolean, :hash, :array
      )
    end
  end
end
