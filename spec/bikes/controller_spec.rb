require "csv"
require "json"
require_relative "./../../bikes/controller"

RSpec.describe Bikes::Controller do
  let(:controller) { Bikes::Controller.new }

  before(:each) do
    allow(CSV).to receive(:read).and_return([])
    allow(CSV).to receive(:open)
  end

  describe "#index" do
    it "returns the list of bikes" do
      allow(controller).to receive(:read_database).and_return([{id: 1, name: "Mountain Bike"}])

      response = controller.index(nil)

      expect(response).to eq([200, {"content-type" => "application/json"}, [[{id: 1, name: "Mountain Bike"}].to_json]])
    end
  end

  describe "#create" do
    it "creates a new bike" do
      allow(controller).to receive(:read_database).and_return([])
      allow(controller).to receive(:write_database)

      request = double("request", body: double("body", read: {name: "Mountain Bike"}.to_json))

      response = controller.create(request)

      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
      expect(controller).to have_received(:write_database).with([{"id" => 1, "name" => "Mountain Bike"}])
    end
  end

  describe "#read" do
    it "returns the bike with the given id if it exists" do
      allow(controller).to receive(:read_database).and_return([{"id" => 1, "name" => "Mountain Bike"}])

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
      allow(controller).to receive(:read_database).and_return([{"id" => 1, "name" => "Mountain Bike"}])
      allow(controller).to receive(:write_database)

      request = double("request", body: double("body", read: {name: "Road Bike"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
      expect(controller).to have_received(:write_database).with([{"name" => "Road Bike"}])
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
      allow(controller).to receive(:read_database).and_return([{"id" => 1, "name" => "Mountain Bike"}])
      allow(controller).to receive(:write_database)

      response = controller.delete(nil, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
      expect(controller).to have_received(:write_database).with([])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow(controller).to receive(:read_database).and_return([])

      response = controller.delete(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end
end
