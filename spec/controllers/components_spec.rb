require_relative "../spec_helper"

RSpec.describe App::Controllers::Components do
  let(:controller) { App::Controllers::Components.new }

  describe "#index" do
    subject(:response) { controller.index(request) }
    let(:request) { double("request", params: {}) }

    before do
      allow_any_instance_of(App::Repositories::Components).to receive(:all).and_return([{"id" => 1, "name" => "Component 1", "description" => "Description 1"}])
    end

    it "returns the list of components" do
      expect(response).to eq([200, {"content-type" => "application/json"}, [[{"id" => 1, "name" => "Component 1", "description" => "Description 1"}].to_json]])
    end
  end

  describe "#create" do
    subject(:response) { controller.create(request) }
    let(:request) { double("request", body: double("body", read: {"name" => "New Component", "description" => "New Description"}.to_json))  }

    before do
      allow_any_instance_of(App::Repositories::Components).to receive(:create).and_return([{id: 1, name: "New Component", description: "New Description"}])
    end

    it "creates a new component" do
      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
    end
  end

  describe "#read" do
    subject(:response) { controller.read(nil, 1) }
    before do
      allow_any_instance_of(App::Repositories::Components).to receive(:find).and_return({"id" => 1, "name" => "Component 1", "description" => "Description 1"})
    end

    it "returns the component with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "application/json"}, [{"id" => 1, "name" => "Component 1", "description" => "Description 1"}.to_json]])
    end

    context "when the component does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Components).to receive(:find).and_raise(App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#update" do
    subject(:response) { controller.update(request, 1) }
    let(:request) { double("request", body: double("body", read: {"id" => 1, "name" => "Updated Component", "description" => "Updated Description"}.to_json))}

    before do
      allow_any_instance_of(App::Repositories::Components).to receive(:update).and_return(true)
    end

    it "updates the component with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
    end

    context "when the component does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Components).to receive(:update).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#delete" do
    subject(:response) { controller.delete(nil, 1) }
    before do
      allow_any_instance_of(App::Repositories::Components).to receive(:delete).and_return(true)
    end

    it "deletes the component with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
    end

    context "when the component does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Components).to receive(:delete).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end
end
