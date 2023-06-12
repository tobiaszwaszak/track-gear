require "rack/test"
require "json"
require "byebug"

require_relative "./../../bikes/app"

RSpec.describe Bikes::App do
  include Rack::Test::Methods

  def app
    Bikes::App.new
  end

  before do
    bikes_data = [JSON.parse({"id" => 1, "name" => "Mountain Bike"}.to_json)]
    CSV.open("bikes.csv", "w", write_headers: true, headers: bikes_data.first.keys) do |csv|
      bikes_data.each { |bike| csv << bike.values }
    end
  end

  let(:bike_data) { {id: 1, name: "Mountain Bike"}.to_json }

  it "creates a new bike" do
    post "/bikes", bike_data

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a bike with the given id" do
    get "/bikes/1"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({id: "1", name: "Mountain Bike"}.to_json)
  end

  it "updates a bike with the given id" do
    put "/bikes/1", bike_data

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID 1")
  end

  it "deletes a bike with the given id" do
    delete "/bikes/1"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Delete with ID 1")
  end
end
