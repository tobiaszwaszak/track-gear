require "rack/test"
require_relative "../../component_assignments/app"

RSpec.describe ComponentAssignments::App do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe "POST /component_assignments" do
    it "creates a new component assignment" do
      allow_any_instance_of(ComponentAssignments::Controller).to receive(:create).and_return([201, {}, ["Create"]])

      post "/component_assignments", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(201)
      expect(last_response.body).to eq("Create")
    end

    it "returns an error when creating a component assignment fails" do
      allow_any_instance_of(ComponentAssignments::Controller).to receive(:create).and_return([500, {}, ["Error creating component"]])

      post "/component_assignments", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(500)
      expect(last_response.body).to eq("Error creating component")
    end
  end

  describe "DELETE /component_assignments/:id" do
    it "deletes the specified component assignment" do
      allow_any_instance_of(ComponentAssignments::Controller).to receive(:delete).and_return([200, {}, ["Delete with ID 1"]])

      delete "/component_assignments/1"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Delete with ID 1")
    end
  end

  describe "Unsupported endpoints" do
    it "returns Method Not Allowed for unsupported endpoints" do
      get "/component_assignments"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")

      put "/component_assignments/1"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")

      patch "/component_assignments/1"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")
    end
  end
end