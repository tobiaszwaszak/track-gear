require "json"
require_relative "./../../component_assignments/controller"

RSpec.describe ComponentAssignments::Controller do
  let(:controller) { ComponentAssignments::Controller.new }

  describe "#create" do
    let(:request) { instance_double("Rack::Request", body: StringIO.new) }

    it "creates a new component assignment" do
      request_body = {"bike_id" => 1, "component_id" => 1}
      allow(request.body).to receive(:read).and_return(request_body.to_json)

      allow_any_instance_of(ComponentAssignments::Repository).to receive(:create).and_return(true)

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

      allow_any_instance_of(ComponentAssignments::Repository).to receive(:create).and_return(nil)

      response = controller.create(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error creating component assignments"])
    end
  end

  describe "#delete" do
    let(:request) { instance_double("Rack::Request") }
    let(:assignment_id) { 1 }

    it "deletes an existing component assignment" do
      # Stub the Repository delete method to return true (success)
      allow_any_instance_of(ComponentAssignments::Repository).to receive(:delete).and_return(true)

      response = controller.delete(request, assignment_id)

      expect(response[0]).to eq(200) # Status code 200 (OK)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Delete with ID #{assignment_id}"])
    end

    it "returns an error when Repository delete method raises RecordNotFound" do
      # Stub the Repository delete method to raise RecordNotFound
      allow_any_instance_of(ComponentAssignments::Repository).to receive(:delete).and_raise(ComponentAssignments::RecordNotFound)

      response = controller.delete(request, assignment_id)

      expect(response[0]).to eq(404) # Status code 404 (Not Found)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Not Found"])
    end

    it "returns an error when Repository delete method fails" do
      # Stub the Repository delete method to return false (failure)
      allow_any_instance_of(ComponentAssignments::Repository).to receive(:delete).and_return(false)

      response = controller.delete(request, assignment_id)

      expect(response[0]).to eq(500) # Status code 500 (Internal Server Error)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Error deleting component assignments"])
    end
  end
end
