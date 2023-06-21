require "rack/test"
require "json"

require_relative "./../../bikes/app"

RSpec.describe Bikes::App do
  include Rack::Test::Methods

  def app
    Bikes::App.new
  end

  before do
    ActiveRecord::Base.establish_connection(
      adapter: "sqlite3",
      database: ENV["BIKES_DB"]
    )
  end

  let(:bike_data) { {name: "Mountain Bike"}.to_json }

  it "creates a new bike" do
    post "/bikes", bike_data

    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq("Create")
  end

  it "reads a bike with the given id" do
    bike = Db::Bike.create(name: "Mountain Bike")

    get "/bikes/#{bike.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq({id: bike.id, name: bike.name}.to_json)
  end

  it "updates a bike with the given id" do
    bike = Db::Bike.create(name: "Mountain Bike")

    put "/bikes/#{bike.id}", bike_data

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Update with ID #{bike.id}")
  end

  it "deletes a bike with the given id" do
    bike = Db::Bike.create(name: "Mountain Bike")

    delete "/bikes/#{bike.id}"

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq("Delete with ID #{bike.id}")
  end
end
