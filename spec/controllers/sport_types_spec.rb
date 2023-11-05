require_relative "../spec_helper"

RSpec.describe App::Controllers::SportTypes do
  let(:controller) { described_class.new }

  describe "#index" do
    subject(:response) { controller.index(request) }
    let(:request) { double("request") }
    let(:sport_type1) { App::Records::SportType.create(name: "Sport Type 1") }
    let(:sport_type2) { App::Records::SportType.create(name: "Sport Type 2") }

    before do
      sport_type1
      sport_type2
    end

    it "returns a JSON response with a list of sport types" do
      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("application/json")

      sport_types = JSON.parse(response[2][0])
      expect(sport_types).to include(
        a_hash_including("id" => sport_type1["id"], "name" => sport_type1["name"]),
        a_hash_including("id" => sport_type2["id"], "name" => sport_type2["name"])
      )
    end
  end

  describe "#create" do
    let(:response) { controller.create(request) }
    let(:sport_type_data) { {"name" => "New Sport Type"} }
    let(:request) {double("request", body: double("body", read: sport_type_data.to_json))  }

    it "creates a new sport type and returns a success response" do
      expect(response[0]).to eq(201)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Create")
    end

    context "when the contract has errors" do
      let(:sport_type_data) { {"name" => ""} }

      it "returns an error response" do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2][0]).to eq("Error creating sport type")
      end
    end
  end

  describe "#read" do
    subject(:response) { controller.read(request, request_id) }
    let(:request_id) { sport_type["id"] }
    let(:sport_type) { App::Records::SportType.create(name: "Sport Type 1")}
    let(:request) { double("request") }
    before do
      sport_type
    end

    it "returns a JSON response with the specified sport type" do
      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("application/json")

      sport_type_data = JSON.parse(response[2][0])
      expect(sport_type_data).to include("id" => sport_type["id"], "name" => sport_type["name"])
    end

    context "when the sport type is not found" do
      let(:request_id) { 12345 }
      it "returns a not found response " do
        expect(response[0]).to eq(404)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2][0]).to eq("Not Found")
      end
    end
  end

  describe "#update" do
    subject(:response) { controller.update(request, request_id) }
    let(:request_id) { sport_type["id"] }
    let(:sport_type) { App::Records::SportType.create(name: "Sport Type 1") }
    let(:sport_type_data) { {"name" => "Updated Sport Type"} }
    let(:request) { double("request", body: double("body", read: sport_type_data.to_json)) }

    before do
      sport_type
    end

    it "updates an existing sport type and returns a success response" do
      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Update with ID #{sport_type["id"]}")
    end

    context "when the contract has errors" do
      let(:sport_type_data) { {"name" => ""} }

      it "returns an error response " do
        expect(response[0]).to eq(500)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2][0]).to eq("Error creating sport type")
      end
    end

    context "when sport type update fails" do
      let(:sport_type_data) { {"name" => "Updated Sport Type"} }
      let(:request_id) { 123345 }

      it "returns an error response" do
        expect(response[0]).to eq(404)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2][0]).to eq("Not Found")
      end
    end
  end

  describe "#delete" do
    subject(:response) { controller.delete(request, request_id) }
    let(:request_id) { sport_type["id"] }
    let(:sport_type) { App::Records::SportType.create(name: "Sport Type 1") }
    let(:request) { double("request") }

    it "deletes an existing sport type and returns a success response" do
      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Delete with ID #{sport_type["id"]}")
    end

    context "when sport type deletion fails" do
      let(:request_id) { 123456 }

      it "returns an error response" do
        expect(response[0]).to eq(404)
        expect(response[1]["content-type"]).to eq("text/plain")
        expect(response[2][0]).to eq("Not Found")
      end
    end
  end
end
