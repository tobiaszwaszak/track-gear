require_relative "../spec_helper"

RSpec.describe App::Routers::Bikes do
  include Rack::Test::Methods

  def app
    App::Routers::Bikes.new
  end

  let(:bike_data) { {name: "Mountain Bike"}.to_json }
  let(:bike) { App::Records::Bike.create(name: "Mountain Bike") }

  it "creates a new bike" do
    post "/bikes", bike_data

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a bike with the given id" do
    get "/bikes/#{bike.id}"

    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to include(JSON.parse({id: bike.id, name: bike.name}.to_json))
  end

  it "updates a bike with the given id" do
    put "/bikes/#{bike.id}", bike_data

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID #{bike.id}")
  end

  it "deletes a bike with the given id" do
    delete "/bikes/#{bike.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Delete with ID #{bike.id}")
  end
end
