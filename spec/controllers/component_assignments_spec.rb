require_relative "../spec_helper"

RSpec.describe App::Controllers::ComponentAssignments do
  let(:controller) { App::Controllers::ComponentAssignments.new }
  let(:request) { instance_double("Rack::Request", body: StringIO.new) }

  before do
    allow(request.body).to receive(:read).and_return(request_body.to_json)
  end

  describe "#create" do
    subject(:response) { controller.create(request) }
    let(:request_body) { {"bike_id" => 1, "component_id" => 1} }
    before do
      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:create).and_return(true)
    end

    it "creates a new component assignment" do
      expect(response[0]).to eq(201)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Create"])
    end

    context "when contract validation fails" do
      let(:request_body) { {"bike_id" => 1, "component_id" => nil} }

      it "returns an error" do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2]).to eq(["Error creating component"])
      end
    end

    context "when Repository create method fails" do
      let(:request_body) { {"bike_id" => 1, "component_id" => 1} }

      before do
        allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:create).and_return(nil)
      end

      it "returns an error " do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2]).to eq(["Error creating component assignments"])
      end
    end
  end

  describe "#delete" do
    subject(:response) { controller.delete(request) }
    let(:request_body) { {"bike_id" => 1, "component_id" => 1} }

    before do
      allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_return(true)
    end

    it "deletes a component assignment" do
      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2]).to eq(["Delete assignment"])
    end

    context "when the record is not found" do
      before do
        allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_raise(App::Repositories::RecordNotFound)
      end

      it "returns 404" do
        expect(response[0]).to eq(404)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2]).to eq(["Not Found"])
      end
    end

    context "when Repository delete method fails" do
      before do
        allow_any_instance_of(App::Repositories::ComponentAssignments).to receive(:delete).and_return(false)
      end

      it "returns an error" do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2]).to eq(["Error deleting component assignments"])
      end
    end

    context "when contract validation fails" do
      let(:request_body) { {"bike_id" => 1, "component_id" => nil} }

      it "returns an error " do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2]).to eq(["Error creating component"])
      end
    end
  end
end
