require "json"
require_relative "./../../app/controllers/component_assignments"

RSpec.describe App::Controllers::ComponentAssignments do
  let(:controller) { App::Controllers::ComponentAssignments.new }
  let(:request) { instance_double("Rack::Request", body: StringIO.new) }

  describe "#create" do
    it "creates a new component assignment" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:create).and_return(true)

      response = controller.create(request)

      expect(response[0]).to eq(201)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Create"])
    end

    it "returns an error when contract validation fails" do
      request_body = {"bike_id" => 1, "component_id" => nil}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      response = controller.create(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error creating component"])
    end

    it "returns an error when Repository create method fails" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:create).and_return(nil)

      response = controller.create(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error creating component assignments"])
    end
  end

  describe "#delete" do
    it "deletes a component assignment" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_return(true)

      response = controller.delete(request)

      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Delete assignment"])
    end

    it "returns 404 when the record is not found" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_raise(App::Repositories::RecordNotFound)

      response = controller.delete(request)

      expect(response[0]).to eq(404)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Not Found"])
    end

    it "returns an error when Repository delete method fails" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_return(false)

      response = controller.delete(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error deleting component assignments"])
    end

    it "returns an error when contract validation fails" do
      request_body = {"bike_id" => 1, "component_id" => nil}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      response = controller.delete(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error creating component"])
    end
  end
end