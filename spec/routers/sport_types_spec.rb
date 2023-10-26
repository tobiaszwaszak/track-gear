
require "rack/test"
require_relative "../../app/routers/sport_types"

RSpec.describe App::Routers::SportTypes do
  include Rack::Test::Methods

  def app
    App::Routers::SportTypes.new
  end

  before do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  describe "GET /" do
    it "responds with a 200 status code" do
      get "/"
      expect(last_response.status).to eq(200)
    end
  end

  describe "GET /sport_types" do
    it "responds with a 200 status code" do
      get "/sport_types"
      expect(last_response.status).to eq(200)
    end
  end

  describe "POST /sport_types" do
    let(:sport_type_data) { {name: "example"}.to_json }

    it "responds with a 200 status code" do
      post "/sport_types", sport_type_data
      expect(last_response.status).to eq(201)
    end
  end

  describe "GET /sport_types/:id" do
    it "responds with a 200 status code" do
      sport_type = ::App::Records::SportType.create(name: "example")

      get "/sport_types/#{sport_type.id}"
      expect(last_response.status).to eq(200)
    end
  end

  describe "PUT /sport_types/:id" do
    it "responds with a 200 status code" do
      sport_type = ::App::Records::SportType.create(name: "example")
      sport_type_data = {name: "example"}.to_json

      put "/sport_types/#{sport_type.id}", sport_type_data
      expect(last_response.status).to eq(200)
    end
  end

  describe "DELETE /sport_types/:id" do
    it "responds with a 200 status code" do
      sport_type = ::App::Records::SportType.create(name: "example")

      delete "/sport_types/#{sport_type.id}"
      expect(last_response.status).to eq(200)
    end
  end

  describe "invalid routes" do
    it "responds with a 404 status code for unknown routes" do
      get "/nonexistent_route"
      expect(last_response.status).to eq(404)
    end

    it "responds with a 405 status code for unsupported HTTP methods" do
      patch "/sport_types"
      expect(last_response.status).to eq(405)
    end
  end
end
