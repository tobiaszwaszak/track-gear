require "rack/test"
require "json"

require_relative "./../../components/app"
require_relative "./../../db/bike"
require_relative "./../../db/component"

RSpec.describe Components::App do
  include Rack::Test::Methods

  def app
    Components::App.new
  end

  before(:each) do
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ENV["BIKES_DB"]
    )

    b1 = Db::Bike.create(name: "bike1")
    b2 = Db::Bike.create(name: "bike2")
    Db::Component.create(name: "Component 1", description: "Description 1", bike: b1)
    Db::Component.create(name: "Component 2", description: "Description 2", bike: b2)
  end

  describe "POST /components" do
    it "creates a new component" do
      component_data = {"name" => "New Component", "description" => "New Description"}.to_json

      post "/components", component_data, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(201)
      expect(last_response.body).to eq("Create")
    end
  end

  describe "GET /components/:id" do
    it "returns a component with the given id" do
      get "/components/1"

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to include({"id" => 1, "bike_id" => 1, "name" => "Component 1", "description" => "Description 1"})
    end

    it "returns 404 if the component is not found" do
      get "/components/100"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq("Not Found")
    end
  end

  describe "PUT /components/:id" do
    it "updates a component with the given id" do
      component_data = {"bike_id" => 2, "name" => "Updated Component", "description" => "Updated Description"}.to_json

      put "/components/1", component_data, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Update with ID 1")
    end

    it "returns 404 if the component is not found" do
      component_data = {"bike_id" => 2, "name" => "Updated Component", "description" => "Updated Description"}.to_json

      put "/components/10", component_data, "CONTENT_TYPE" => "application/json"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq("Not Found")
    end
  end

  describe "DELETE /components/:id" do
    it "deletes a component with the given id" do
      delete "/components/1"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq("Delete with ID 1")
    end

    it "returns 404 if the component is not found" do
      delete "/components/100"

      expect(last_response.status).to eq(404)
      expect(last_response.body).to eq("Not Found")
    end
  end
end
