require "csv"
require "json"
require_relative "./../../bikes/controller"

RSpec.describe Bikes::Controller do
  let(:controller) { Bikes::Controller.new }

  describe "#index" do
    it "returns the list of bikes" do
      allow(Db::Bike).to receive(:all).and_return([{id: 1, name: "Mountain Bike"}])

      response = controller.index(nil)

      expect(response).to eq([200, {"content-type" => "application/json"}, [[{id: 1, name: "Mountain Bike"}].to_json]])
    end
  end

  describe "#create" do
    it "creates a new bike" do
      allow(Db::Bike).to receive(:create).and_return([{id: 1, name: "Mountain Bike"}])

      request = double("request", body: double("body", read: {name: "Mountain Bike"}.to_json))

      response = controller.create(request)

      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
      expect(Db::Bike).to have_received(:create).with({"name" => "Mountain Bike"})
    end
  end

  describe "#read" do
    it "returns the bike with the given id if it exists" do
      allow(Db::Bike).to receive(:find_by).and_return({id: 1, name: "Mountain Bike"})

      response = controller.read(nil, 1)

      expect(response).to eq([200, {"content-type" => "application/json"}, [{id: 1, name: "Mountain Bike"}.to_json]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow(controller).to receive(:read_database).and_return([])

      response = controller.read(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#update" do
    it "updates the bike with the given id if it exists" do
      allow(Db::Bike).to receive(:find_by).and_return({id: 1, name: "Mountain Bike"})
      allow(Db::Bike).to receive(:update)

      request = double("request", body: double("body", read: {name: "Road Bike"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow(controller).to receive(:read_database).and_return([])

      request = double("request", body: double("body", read: {name: "Road Bike"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#delete" do
    it "deletes the bike with the given id if it exists" do
      bike = double("bike", {id: 1, name: "Mountain Bike"})
      allow(Db::Bike).to receive(:find_by).and_return(bike)
      allow(bike).to receive(:destroy).and_return(true)

      response = controller.delete(nil, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow(Db::Bike).to receive(:find_by).and_return(nil)

      response = controller.delete(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end
end
