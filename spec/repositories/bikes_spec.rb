require_relative "../spec_helper"

RSpec.describe App::Repositories::Bikes do
  let(:repository) { App::Repositories::Bikes.new }

  describe "#all" do
    it "returns all bikes" do
      bike1 = ::App::Records::Bike.create(name: "Mountain Bike")
      bike2 = ::App::Records::Bike.create(name: "Road Bike")

      result = repository.all

      expect(result.map { |item| item[:id] }).to include(bike1.id, bike2.id)
      expect(result.map { |item| item[:name] }).to include("Mountain Bike", "Road Bike")
    end
  end

  describe "#create" do
    it "creates a new bike" do
      name = "Mountain Bike"

      result = repository.create(name: name, brand: nil, model: nil, weight: nil, notes: nil, commute: nil)

      expect(result[:id]).to be_a(Integer)
      expect(result[:name]).to eq(name)
    end
  end

  describe "#find" do
    it "finds a bike by id" do
      bike = ::App::Records::Bike.create(name: "Mountain Bike")

      result = repository.find(id: bike.id)

      expect(result[:id]).to eq(bike.id)
      expect(result[:name]).to eq(bike.name)
    end

    it "raises ::App::Repositories::RecordNotFound when the bike is not found" do
      expect { repository.find(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
    end
  end

  describe "#update" do
    it "updates a bike with the given id and params" do
      bike = ::App::Records::Bike.create(name: "Mountain Bike")

      updated_bike = repository.update(id: bike.id, params: {name: "Road Bike"})

      expect(updated_bike[:id]).to eq(bike.id)
      expect(updated_bike[:name]).to eq("Road Bike")

      updated_record = ::App::Records::Bike.find(bike.id)
      expect(updated_record.name).to eq("Road Bike")
    end

    it "raises ::App::Repositories::RecordNotFound when the bike is not found" do
      expect { repository.update(id: 123, params: {name: "Road Bike"}) }.to raise_error(::App::Repositories::RecordNotFound)
    end
  end

  describe "#delete" do
    it "deletes a bike with the given id" do
      bike = ::App::Records::Bike.create(name: "Mountain Bike")

      repository.delete(id: bike.id)

      expect { ::App::Records::Bike.find(bike.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises ::App::Repositories::RecordNotFound when the bike is not found" do
      expect { repository.delete(id: 123) }.to raise_error(::App::Repositories::RecordNotFound)
    end
  end
end
