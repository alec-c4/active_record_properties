# frozen_string_literal: true

RSpec.describe ActiveRecordProperties::Settable do
  let(:model) { TestModel.new }

  describe "default values" do
    it "sets string default" do
      expect(model.name).to eq("default")
    end

    it "sets integer default" do
      expect(model.count).to eq(0)
    end

    it "sets float default" do
      expect(model.rate).to eq(1.5)
    end

    it "sets boolean default" do
      expect(model.enabled).to be true
    end

    it "sets hash default from proc" do
      expect(model.config).to eq({})
    end

    it "sets array default from proc" do
      expect(model.tags).to eq([])
    end
  end

  describe "setting values" do
    it "sets and retrieves string value" do
      model.name = "test"
      expect(model.name).to eq("test")
    end

    it "sets and retrieves integer value" do
      model.count = 42
      expect(model.count).to eq(42)
    end

    it "sets and retrieves float value" do
      model.rate = 3.14
      expect(model.rate).to eq(3.14)
    end

    it "sets and retrieves boolean value" do
      model.enabled = false
      expect(model.enabled).to be false
    end

    it "sets and retrieves hash value" do
      model.config = {"key" => "value"}
      expect(model.config).to eq({"key" => "value"})
    end

    it "sets and retrieves array value" do
      model.tags = ["tag1", "tag2"]
      expect(model.tags).to eq(["tag1", "tag2"])
    end
  end

  describe "persistence" do
    it "persists properties to database" do
      model.name = "persisted"
      model.count = 100
      model.save!

      reloaded = TestModel.find(model.id)
      expect(reloaded.name).to eq("persisted")
      expect(reloaded.count).to eq(100)
    end

    it "stores all properties in JSONB column" do
      model.name = "test"
      model.count = 5
      model.save!

      expect(model.properties).to include("name" => "test", "count" => 5)
    end
  end

  describe "isolation" do
    it "each instance has independent default hash" do
      model1 = TestModel.new
      model2 = TestModel.new

      model1.config["key"] = "value1"
      expect(model2.config).not_to have_key("key")
    end

    it "each instance has independent default array" do
      model1 = TestModel.new
      model2 = TestModel.new

      model1.tags << "tag1"
      expect(model2.tags).to be_empty
    end
  end
end
