require_relative "../spec_helper"

RSpec.describe App::Routers::BikeSportTypes do
  include Rack::Test::Methods

  let(:app) { described_class.new }

  describe "POST /bike_sport_types" do
    before do
      allow_any_instance_of(App::Controllers::BikeSportTypes).to receive(:create).and_return([201, {}, ["Create"]])
    end

    it "creates a new bike sport type" do
      post "/bike_sport_types", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(201)
      expect(last_response.body).to eq("Create")
    end

    context "when creating a bike sport type fails" do
      before do
        allow_any_instance_of(App::Controllers::BikeSportTypes).to receive(:create).and_return([500, {}, ["Error creating component"]])
      end

      it "returns an error" do
        post "/bike_sport_types", {}.to_json, "CONTENT_TYPE" => "application/json"

        expect(last_response.status).to eq(500)
        expect(last_response.body).to eq("Error creating component")
      end
    end
  end

  describe "DELETE /bike_sport_types" do
    before do
      allow_any_instance_of(App::Controllers::BikeSportTypes).to receive(:delete).and_return([200, {}, ["Delete assignment"]])
    end

    it "deletes the specified bike sport type" do
      delete "/bike_sport_types", {}.to_json, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Delete assignment")
    end
  end

  describe "Unsupported endpoints" do
    it "returns Method Not Allowed for unsupported endpoints" do
      get "/bike_sport_types"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")

      put "/bike_sport_types/1"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")

      patch "/bike_sport_types/1"
      expect(last_response.status).to eq(405)
      expect(last_response.body).to eq("Method Not Allowed")
    end
  end
end
