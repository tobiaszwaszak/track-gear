require "json"
require "active_record"
require_relative "../db/bike"
require "byebug"

module Bikes
  class Controller
    def initialize
      setup_database
    end

    def index(request)
      bikes = Db::Bike.all
      [200, {"content-type" => "application/json"}, [bikes.to_json]]
    end

    def create(request)
      bike_data = JSON.parse(request.body.read)
      bike = Db::Bike.create(bike_data)
      if bike
        [201, {"content-type" => "text/plain"}, ["Create"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
      end
    end

    def read(request, bike_id)
      bike = Db::Bike.find_by(id: bike_id)
      if bike
        [200, {"content-type" => "application/json"}, [bike.to_json]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def update(request, bike_id)
      bike_data = JSON.parse(request.body.read)
      bike = Db::Bike.find_by(id: bike_id)
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
      bike = Db::Bike.find_by(id: bike_id)
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
      ActiveRecord::Base.configurations = YAML.load_file('db/configuration.yml')
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end
  end
end
