require "csv"
require "json"
require_relative "./../../bikes/controller"

RSpec.describe Bikes::Controller do
  let(:controller) { Bikes::Controller.new }

  describe "#index" do
    it "returns the list of bikes" do
      allow_any_instance_of(Bikes::Repository).to receive(:all).and_return([{id: 1, name: "Mountain Bike"}])

      response = controller.index(nil)

      expect(response).to eq([200, {"content-type" => "application/json"}, [[{id: 1, name: "Mountain Bike"}].to_json]])
    end
  end

  describe "#create" do
    it "creates a new bike" do
      allow_any_instance_of(Bikes::Repository).to receive(:create).and_return([{id: 1, name: "Mountain Bike"}])

      request = double("request", body: double("body", read: {name: "Mountain Bike"}.to_json))

      response = controller.create(request)

      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
    end
  end

  describe "#read" do
    it "returns the bike with the given id if it exists" do
      allow_any_instance_of(Bikes::Repository).to receive(:find).and_return({id: 1, name: "Mountain Bike"})

      response = controller.read(nil, 1)

      expect(response).to eq([200, {"content-type" => "application/json"}, [{id: 1, name: "Mountain Bike"}.to_json]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow_any_instance_of(Bikes::Repository).to receive(:find).and_raise(ActiveRecord::RecordNotFound)

      response = controller.read(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#update" do
    it "updates the bike with the given id if it exists" do
      allow_any_instance_of(Bikes::Repository).to receive(:update).and_return({id: 1, name: "Mountain Bike"})

      request = double("request", body: double("body", read: {name: "Road Bike"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow_any_instance_of(Bikes::Repository).to receive(:update).and_raise(ActiveRecord::RecordNotFound)

      request = double("request", body: double("body", read: {name: "Road Bike"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#delete" do
    it "deletes the bike with the given id if it exists" do
      allow_any_instance_of(Bikes::Repository).to receive(:delete).and_return(true)

      response = controller.delete(nil, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
    end

    it "returns 404 Not Found if the bike does not exist" do
      allow_any_instance_of(Bikes::Repository).to receive(:delete).and_raise(ActiveRecord::RecordNotFound)

      response = controller.delete(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end
end
