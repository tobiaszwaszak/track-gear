require "rack/test"
require "json"
require_relative "../app"

RSpec.describe MyApp do
  include Rack::Test::Methods

  def app
    MyApp.new
  end

  before(:all) do
    ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
    ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
  end

  after(:all) do
    ActiveRecord::Base.remove_connection
  end

  describe "GET /bikes" do
    it "calls Bikes::App" do
      expect_any_instance_of(App::Routers::Bikes).to receive(:call).and_call_original
      get "/bikes", {}
    end
  end

  describe "POST /component_assignments" do
    it "calls ComponentAssignments::App" do
      bike = ::App::Records::Bike.create(name: "foo")
      component = ::App::Records::Component.create(name: "bar")

      expect_any_instance_of(App::Routers::ComponentAssignments).to receive(:call).and_call_original
      post "/component_assignments", {bike_id: bike.id, component_id: component.id}.to_json
    end
  end

  describe "GET /accounts/1" do
    it "calls Accounts::App" do
      expect_any_instance_of(App::Routers::Accounts).to receive(:call).and_call_original
      get "/accounts/1"
    end
  end

  describe "GET /" do
    it "returns index.html content" do
      get "/"
      expect(last_response).to be_ok
      expect(last_response.header["Content-Type"]).to eq("text/html")
      expect(last_response.body).to include("Bikes Frontend")
    end
  end

  describe "GET /environment" do
    it "returns environment name" do
      get "/environment"
      expect(last_response).to be_ok
      expect(last_response.header["Content-Type"]).to eq("text/plain")
      expect(last_response.body).to eq("test")
    end
  end

  describe "GET unknown path" do
    it "returns 404 Not Found" do
      get "/unknown", {}
      expect(last_response.status).to eq(404)
      expect(last_response.header["Content-Type"]).to eq("text/plain")
      expect(last_response.body).to eq("Not Found")
    end
  end
end
