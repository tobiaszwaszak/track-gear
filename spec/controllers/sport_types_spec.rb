require_relative "../spec_helper"

RSpec.describe App::Controllers::SportTypes do
  let(:controller) { described_class.new }

  before do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  describe "#index" do
    it "returns a JSON response with a list of sport types" do
      # Create test data in the database
      sport_type1 = App::Records::SportType.create(name: "Sport Type 1")
      sport_type2 = App::Records::SportType.create(name: "Sport Type 2")

      request = double("request")
      response = controller.index(request)

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
    it "creates a new sport type and returns a success response" do
      sport_type_data = {"name" => "New Sport Type"}

      request = double("request", body: double("body", read: sport_type_data.to_json))
      response = controller.create(request)

      expect(response[0]).to eq(201)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Create")
    end

    it "returns an error response when the contract has errors" do
      sport_type_data = {"name" => ""}

      request = double("request", body: double("body", read: sport_type_data.to_json))
      response = controller.create(request)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Error creating sport type")
    end
  end

  describe "#read" do
    it "returns a JSON response with the specified sport type" do
      sport_type = App::Records::SportType.create(name: "Sport Type 1")

      request = double("request")
      response = controller.read(request, sport_type["id"])

      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("application/json")

      sport_type_data = JSON.parse(response[2][0])
      expect(sport_type_data).to include("id" => sport_type["id"], "name" => sport_type["name"])
    end

    it "returns a not found response when the sport type is not found" do
      request = double("request")
      response = controller.read(request, 12345)

      expect(response[0]).to eq(404)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Not Found")
    end
  end

  describe "#update" do
    it "updates an existing sport type and returns a success response" do
      sport_type = App::Records::SportType.create(name: "Sport Type 1")
      sport_type_data = {"name" => "Updated Sport Type"}

      request = double("request", body: double("body", read: sport_type_data.to_json))
      response = controller.update(request, sport_type["id"])

      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Update with ID #{sport_type["id"]}")
    end

    it "returns an error response when the contract has errors" do
      sport_type_data = {"name" => ""}

      request = double("request", body: double("body", read: sport_type_data.to_json))
      response = controller.update(request, 1)

      expect(response[0]).to eq(500)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Error creating sport type")
    end

    it "returns an error response when sport type update fails" do
      sport_type_data = {"name" => "Updated Sport Type"}

      request = double("request", body: double("body", read: sport_type_data.to_json))
      response = controller.update(request, 12345)  # An ID that won't exist

      expect(response[0]).to eq(404)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Not Found")
    end
  end

  describe "#delete" do
    it "deletes an existing sport type and returns a success response" do
      sport_type = App::Records::SportType.create(name: "Sport Type 1")

      request = double("request")
      response = controller.delete(request, sport_type["id"])

      expect(response[0]).to eq(200)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Delete with ID #{sport_type["id"]}")
    end

    it "returns an error response when sport type deletion fails" do
      request = double("request")
      response = controller.delete(request, 12345)

      expect(response[0]).to eq(404)
      expect(response[1]["content-type"]).to eq("text/plain")
      expect(response[2][0]).to eq("Not Found")
    end
  end
end
