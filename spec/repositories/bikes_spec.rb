require_relative "../spec_helper"

RSpec.describe App::Repositories::Bikes do
  let(:repository) { App::Repositories::Bikes.new }
  let(:bike) { App::Records::Bike.create(name: "Mountain Bike") }

  describe "#all" do
    subject(:result) { repository.all }
    let(:bike1) { App::Records::Bike.create(name: "Mountain Bike") }
    let(:bike2) { App::Records::Bike.create(name: "Road Bike") }

    before do
      bike1
      bike2
    end

    it "returns all bikes" do
      expect(result.map { |item| item[:id] }).to include(bike1.id, bike2.id)
      expect(result.map { |item| item[:name] }).to include("Mountain Bike", "Road Bike")
    end
  end

  describe "#create" do
    subject(:result) {repository.create(name: name, brand: nil, model: nil, weight: nil, notes: nil, commute: nil) }
    let(:name) { "Mountain Bike" }

    it "creates a new bike" do
      expect(result[:id]).to be_a(Integer)
      expect(result[:name]).to eq(name)
    end
  end

  describe "#find" do
    subject(:result) { repository.find(id: bike.id) }

    it "finds a bike by id" do
      expect(result[:id]).to eq(bike.id)
      expect(result[:name]).to eq(bike.name)
    end

    context "when the bike is not found" do
      it "raises ::App::Repositories::RecordNotFound " do
        expect { repository.find(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#update" do
    subject(:update_bike) { repository.update(id: request_id, params: {name: "Road Bike"}) }
    let(:request_id) { bike.id }
    let(:updated_record) { App::Records::Bike.find(bike.id) }

    it "updates a bike with the given id and params" do
      expect(update_bike[:id]).to eq(bike.id)
      expect(update_bike[:name]).to eq("Road Bike")

      expect(updated_record.name).to eq("Road Bike")
    end

    context "when the bike is not found" do
      let(:request_id) { 12345 }

      it "raises ::App::Repositories::RecordNotFound " do
        expect { update_bike }.to raise_error(::App::Repositories::RecordNotFound)
      end
    end
  end

  describe "#delete" do
    it "deletes a bike with the given id" do
      repository.delete(id: bike.id)

      expect { ::App::Records::Bike.find(bike.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises ::App::Repositories::RecordNotFound when the bike is not found" do
      expect { repository.delete(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
    end
  end
end
