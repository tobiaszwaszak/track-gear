require "rack/test"
require "json"
require "byebug"
require_relative "./../../components/app"

RSpec.describe Components::App do
  include Rack::Test::Methods

  def app
    Components::App.new
  end

  before do
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ENV["BIKES_DB"]
    )
    Db::Component.create(name: "some part")
  end

  let(:component_data) { {name: "some part"}.to_json }

  it "creates a new bike" do
    post "/components", component_data

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a bike with the given id" do
    component = Db::Component.create(name: "some part")
    get "/components/#{component.id}"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to include(JSON.parse({id: component.id, name: component.name}.to_json))
  end

  it "updates a bike with the given id" do
    component = Db::Component.create(name: "some part")
    put "/components/#{component.id}", component_data

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID #{component.id}")
  end

  it "deletes a bike with the given id" do
    component = Db::Component.create(name: "some part")

    delete "/components/#{component.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Delete with ID #{component.id}")
  end
end
