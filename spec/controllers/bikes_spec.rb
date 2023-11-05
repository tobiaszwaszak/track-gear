require_relative "../spec_helper"

RSpec.describe App::Controllers::Bikes do
  let(:controller) { App::Controllers::Bikes.new }

  describe "#index" do
    subject(:response) { controller.index(nil) }

    before do
      allow_any_instance_of(App::Repositories::Bikes).to receive(:all).and_return([{id: 1, name: "Mountain Bike"}])
    end

    it "returns the list of bikes" do
      expect(response).to eq([200, {"content-type" => "application/json"}, [[{id: 1, name: "Mountain Bike"}].to_json]])
    end
  end

  describe "#create" do
    subject(:response) { controller.create(request) }
    let(:request) { double("request", body: double("body", read: {name: "Mountain Bike"}.to_json)) }

    before do
      allow_any_instance_of(App::Repositories::Bikes).to receive(:create).and_return([{id: 1, name: "Mountain Bike"}])
    end

    it "creates a new bike" do
      expect(response).to eq([201, {"content-type" => "text/plain"}, ["Create"]])
    end
  end

  describe "#read" do
    subject(:response) { controller.read(nil, 1) }

    before do
      allow_any_instance_of(App::Repositories::Bikes).to receive(:find).and_return({id: 1, name: "Mountain Bike"})
    end

    it "returns the bike with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "application/json"}, [{id: 1, name: "Mountain Bike"}.to_json]])
    end

    context "when the bike does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Bikes).to receive(:find).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#update" do
    subject(:response) { controller.update(request, 1) }
    let(:request) { double("request", body: double("body", read: {name: "Road Bike"}.to_json)) }

    before do
      allow_any_instance_of(App::Repositories::Bikes).to receive(:update).and_return({id: 1, name: "Mountain Bike"})
    end

    it "updates the bike with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Update with ID 1"]])
    end

    context "when the bike does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Bikes).to receive(:update).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end

  describe "#delete" do
    subject(:response) { controller.delete(nil, 1) }

    before do
      allow_any_instance_of(App::Repositories::Bikes).to receive(:delete).and_return(true)
    end

    it "deletes the bike with the given id if it exists" do
      expect(response).to eq([200, {"content-type" => "text/plain"}, ["Delete with ID 1"]])
    end

    context "when the bike does not exist" do
      before do
        allow_any_instance_of(App::Repositories::Bikes).to receive(:delete).and_raise(::App::Repositories::RecordNotFound)
      end

      it "returns 404 Not Found" do
        expect(response).to eq([404, {"content-type" => "text/plain"}, ["Not Found"]])
      end
    end
  end
end
