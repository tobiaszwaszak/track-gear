require "csv"
require "json"
require_relative "./../../components/controller"

RSpec.describe Components::Controller do
  let(:controller) { Components::Controller.new }

  describe "#index" do
    it "returns the list of components" do
      allow_any_instance_of(Components::Repository).to receive(:all).and_return([{"id" => 1, "bike_id" => 1, "name" => "Component 1", "description" => "Description 1"}])

      request = double("request", params: {})

      response = controller.index(request)

      expect(response).to eq([200, {"content-type" => "application/json"}, [[{"id" => 1, "bike_id" => 1, "name" => "Component 1", "description" => "Description 1"}].to_json]])
    end
  end

  describe "#create" do
    it "creates a new component" do
      allow_any_instance_of(Components::Repository).to receive(:create).and_return([{id: 1, name: "New Component", description: "New Description"}])

      request = double("request", body: double("body", read: {"bike_id" => 1, "name" => "New Component", "description" => "New Description"}.to_json))

      response = controller.create(request)

      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
    end
  end

  describe "#read" do
    it "returns the component with the given id if it exists" do
      allow_any_instance_of(Components::Repository).to receive(:find).and_return({"id" => 1, "bike_id" => 1, "name" => "Component 1", "description" => "Description 1"})

      response = controller.read(nil, 1)

      expect(response).to eq([200, {"content-type" => "application/json"}, [{"id" => 1, "bike_id" => 1, "name" => "Component 1", "description" => "Description 1"}.to_json]])
    end

    it "returns 404 Not Found if the component does not exist" do
      allow_any_instance_of(Components::Repository).to receive(:find).and_raise(Components::RecordNotFound)

      response = controller.read(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#update" do
    it "updates the component with the given id if it exists" do
      allow_any_instance_of(Components::Repository).to receive(:update).and_return(true)

      request = double("request", body: double("body", read: {"id" => 1, "bike_id" => 2, "name" => "Updated Component", "description" => "Updated Description"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
    end

    it "returns 404 Not Found if the component does not exist" do
      allow_any_instance_of(Components::Repository).to receive(:update).and_raise(Components::RecordNotFound)
      request = double("request", body: double("body", read: {"bike_id" => 2, "name" => "Updated Component", "description" => "Updated Description"}.to_json))

      response = controller.update(request, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end

  describe "#delete" do
    it "deletes the component with the given id if it exists" do
      allow_any_instance_of(Components::Repository).to receive(:delete).and_return(true)

      response = controller.delete(nil, 1)

      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
    end

    it "returns 404 Not Found if the component does not exist" do
      allow_any_instance_of(Components::Repository).to receive(:delete).and_raise(Components::RecordNotFound)

      response = controller.delete(nil, 1)

      expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
    end
  end
end
