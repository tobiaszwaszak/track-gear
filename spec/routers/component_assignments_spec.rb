require_relative "../spec_helper"

RSpec.describe App::Routers::ComponentAssignments do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe "POST /component_assignments" do
    before do
      allow_any_instance_of(App::Controllers::ComponentAssignments).to receive(:create).and_return([201, {}, ["Create"]])
    end

    it "creates a new component assignment" do
      post "/component_assignments", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(201)
      expect(last_response.body).to eq("Create")
    end

    context "when creating a component assignment fails" do
      before do
        allow_any_instance_of(App::Controllers::ComponentAssignments).to receive(:create).and_return([500, {}, ["Error creating component"]])
      end

      it "returns an error" do
        post "/component_assignments", {}.to_json, "CONTENT_TYPE" => "application/json"

        expect(last_response.status).to eq(500)
        expect(last_response.body).to eq("Error creating component")
      end
    end
  end

  describe "DELETE /component_assignments" do
    before do
      allow_any_instance_of(App::Controllers::ComponentAssignments).to receive(:delete).and_return([200, {}, ["Delete assignment"]])
    end

    it "deletes the specified component assignment" do
      delete "/component_assignments", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Delete assignment")
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
