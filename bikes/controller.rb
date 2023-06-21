require "json"
require "dotenv"
require "active_record"

Dotenv.load(".env.development") if ENV["RACK_ENV"] == "development"
Dotenv.load(".env.test") if ENV["RACK_ENV"] == "test"

module Bikes
  class Bike < ActiveRecord::Base
  end

  class Controller
    def initialize
      setup_database
    end

    def index(request)
      bikes = Bikes::Bike.all
      [200, {"content-type" => "application/json"}, [bikes.to_json]]
    end

    def create(request)
      bike_data = JSON.parse(request.body.read)
      bike = Bikes::Bike.create(bike_data)
      if bike
        [201, {"content-type" => "text/plain"}, ["Create"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
      end
    end

    def read(request, bike_id)
      bike = Bikes::Bike.find_by(id: bike_id)
      if bike
        [200, {"content-type" => "application/json"}, [bike.to_json]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def update(request, bike_id)
      bike_data = JSON.parse(request.body.read)
      bike = Bikes::Bike.find_by(id: bike_id)
      if bike
        if bike.update(bike_data)
          [200, {"content-type" => "text/plain"}, ["Update with ID #{bike_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error updating bike"]]
        end
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def delete(request, bike_id)
      bike = Bikes::Bike.find_by(id: bike_id)
      if bike
        if bike.destroy
          [200, {"content-type" => "text/plain"}, ["Delete with ID #{bike_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error deleting bike"]]
        end
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    private

    def setup_database
      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: ENV["BIKES_DB"]
      )
    end
  end
end
