require_relative "../../db/records/bike"
require_relative "../../bikes/repository"

RSpec.describe Bikes::Repository do
  let(:repository) { Bikes::Repository.new }

  describe "#all" do
    it "returns all bikes" do
      expect(Db::Records::Bike).to receive(:all)
      repository.all
    end
  end

  describe "#create" do
    it "creates a new bike" do
      name = "Mountain Bike"
      expect(Db::Records::Bike).to receive(:create).with(name: name)
      repository.create(name: name)
    end
  end

  describe "#find" do
    it "finds a bike by id" do
      id = 1
      expect(Db::Records::Bike).to receive(:find_by).with(id: id)
      repository.find(id: id)
    end
  end

  describe "#update" do
    it "updates a bike with the given id and params" do
      id = 1
      params = { name: "Road Bike" }
      record = double("record")
      allow(repository).to receive(:find).with(id: id).and_return(record)
      expect(record).to receive(:update).with(params)
      repository.update(id: id, params: params)
    end
  end

  describe "#delete" do
    it "deletes a bike with the given id" do
      id = 1
      record = double("record")
      allow(repository).to receive(:find).with(id: id).and_return(record)
      expect(record).to receive(:destroy!)
      repository.delete(id: id)
    end
  end
end
