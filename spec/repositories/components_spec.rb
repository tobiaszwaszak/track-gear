require_relative "../spec_helper"

RSpec.describe App::Repositories::Components do
  let(:repository) { App::Repositories::Components.new }
  let(:bike) { App::Records::Bike.create(name: "Test Bike") }
  let(:component1) { App::Records::Component.create(name: "Handlebar") }
  let(:component2) { App::Records::Component.create(name: "Saddle") }

  describe "#all" do
    before do
      component1
      component2
    end

    it "returns all components" do
      expect(repository.all.map { |item| item[:id] }).to include(component1.id, component2.id)
      expect(repository.all.map { |item| item[:name] }).to include("Handlebar", "Saddle")
    end
  end

  describe "#all_by_bikes" do
    subject(:components) { repository.all_by_bikes(bike_id: bike.id) }
    let(:today) { Date.today }

    before do
      App::Records::ComponentAssignment.create(bike: bike, component: component1, started_at: today - 2.days, ended_at: today + 2.days)
      App::Records::ComponentAssignment.create(bike: bike, component: component2, started_at: today - 5.days, ended_at: today - 3.days)
    end

    it "returns all components assigned to a specific bike and currently valid" do
      expect(components).to be_an(Array)
      expect(components.length).to eq(1)

      expect(components.first).to include(
        id: component1.id,
        name: component1.name
      )
    end

    context "when no components are assigned to the bike" do
      before do
        App::Records::ComponentAssignment.all.delete_all
      end

      it "returns an empty array" do
        expect(components).to be_an(Array)
        expect(components).to be_empty
      end
    end

    context "when no valid assignments exist for the bike" do
      before do
        App::Records::ComponentAssignment.all.delete_all
        App::Records::ComponentAssignment.create(bike: bike, component: component1, started_at: today - 5.days, ended_at: today - 3.days)
      end

      it "returns an empty array " do
        expect(components).to be_an(Array)
        expect(components).to be_empty
      end
    end
  end

  describe "#create" do
    subject(:result) { repository.create(name: name, brand: nil, model: nil, weight: nil, notes: nil) }
    let(:name) { "Handlebar" }

    it "creates a new component" do
      expect(result[:id]).to be_a(Integer)
      expect(result[:name]).to eq(name)
    end
  end

  describe "#find" do
    subject(:result) { repository.find(id: component1.id) }

    it "finds a component by id" do
      expect(result[:id]).to eq(component1.id)
      expect(result[:name]).to eq(component1.name)
    end

    context "when the component is not found" do
      it "raises ::App::Repositories::RecordNotFound " do
        expect { repository.find(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#update" do
    subject(:result) { repository.update(id: id, params: params) }
    let(:id) { component1.id }
    let(:params) { {name: "Saddle"} }

    it "updates a component with the given id and params" do
      expect(result[:id]).to eq(id)
      expect(result[:name]).to eq(params[:name])
    end

    context "when the component is not found" do
      let(:id) { 12345 }

      it "raises ::App::Repositories::RecordNotFound" do
        expect { result }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#delete" do
    it "deletes a component with the given id" do
      repository.delete(id: component1.id)

      expect { ::App::Records::Component.find(component1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises ::App::Repositories::RecordNotFound when the component is not found" do
      expect { repository.delete(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
    end
  end
end
