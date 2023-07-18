require_relative "../../db/records/bike"
require_relative "../../bikes/repository"

RSpec.describe Components::Repository do
  let(:repository) { Components::Repository.new }

  describe "#all" do
    it "returns all components" do
      component1 = Db::Records::Component.create(name: "Handlebar")
      component2 = Db::Records::Component.create(name: "Saddle")

      result = repository.all

      expect(result.map { |item| item[:id] }).to include(component1.id, component2.id)
      expect(result.map { |item| item[:name] }).to include("Handlebar", "Saddle")
    end
  end

  describe "#all_by" do
    it "returns components filtered by the given filters" do
      component1 = Db::Records::Component.create(name: "Handlebar")
      component2 = Db::Records::Component.create(name: "Saddle")
      filters = {name: "Handlebar"}

      result = repository.all_by(filters)

      expect(result.map { |item| item[:id] }).to include(component1.id)
      expect(result.map { |item| item[:id] }).to_not include(component2.id)
    end
  end

  describe "#create" do
    it "creates a new component" do
      name = "Handlebar"

      result = repository.create(name: name, brand: nil, model: nil, weight: nil, notes: nil)

      expect(result[:id]).to be_a(Integer)
      expect(result[:name]).to eq(name)
    end
  end

  describe "#find" do
    it "finds a component by id" do
      component = Db::Records::Component.create(name: "Handlebar")

      result = repository.find(id: component.id)

      expect(result[:id]).to eq(component.id)
      expect(result[:name]).to eq(component.name)
    end

    it "raises Components::RecordNotFound when the component is not found" do
      expect { repository.find(id: 123) }.to raise_error(Components::RecordNotFound)
    end
  end

  describe "#update" do
    it "updates a component with the given id and params" do
      component = Db::Records::Component.create(name: "Handlebar")

      id = component.id
      params = {name: "Saddle"}

      result = repository.update(id: id, params: params)

      expect(result[:id]).to eq(id)
      expect(result[:name]).to eq(params[:name])
    end

    it "raises Components::RecordNotFound when the component is not found" do
      expect { repository.update(id: 123, params: {name: "Saddle"}) }.to raise_error(Components::RecordNotFound)
    end
  end

  describe "#delete" do
    it "deletes a component with the given id" do
      component = Db::Records::Component.create(name: "Handlebar")

      id = component.id

      repository.delete(id: id)

      expect { Db::Records::Component.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises Components::RecordNotFound when the component is not found" do
      expect { repository.delete(id: 123) }.to raise_error(Components::RecordNotFound)
    end
  end
end
