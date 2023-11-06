require_relative "../spec_helper"

RSpec.describe App::Routers::Components do
  include Rack::Test::Methods

  def app
    App::Routers::Components.new
  end

  let(:component_data) { {name: "some part"}.to_json }
  let(:component) { App::Records::Component.create(name: "some part") }

  it "creates a new bike" do
    post "/components", component_data

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a bike with the given id" do
    get "/components/#{component.id}"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to include(JSON.parse({id: component.id, name: component.name}.to_json))
  end

  it "updates a bike with the given id" do
    put "/components/#{component.id}", component_data

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID #{component.id}")
  end

  it "deletes a bike with the given id" do
    delete "/components/#{component.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Delete with ID #{component.id}")
  end
end
