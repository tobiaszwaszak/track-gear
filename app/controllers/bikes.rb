require "json"
require "byebug"
require_relative "../repositories/bikes"
require_relative "../contracts/bike"

module App
  module Controllers
    class Bikes
      def index(request)
        bikes = Repositories::Bikes.new.all
        [200, {"content-type" => "application/json"}, [bikes.to_json]]
      end

      def create(request)
        bike_data = Contracts::Bike.new.call(JSON.parse(request.body.read))
        if bike_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
        else
          bike = Repositories::Bikes.new.create(
            name: bike_data["name"],
            brand: bike_data["brand"],
            model: bike_data["model"],
            weight: bike_data["weight"],
            notes: bike_data["notes"]
          )
          if bike
            [201, {"content-type" => "text/plain"}, ["Create"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
          end
        end
      end

      def read(request, bike_id)
        bike = Repositories::Bikes.new.find(id: bike_id)
        [200, {"content-type" => "application/json"}, [bike.to_json]]
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end

      def update(request, bike_id)
        bike_data = Contracts::Bike.new.call(JSON.parse(request.body.read))
        if bike_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
        elsif Repositories::Bikes.new.update(id: bike_id, params: bike_data.to_h)
          [200, {"content-type" => "text/plain"}, ["Update with ID #{bike_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error updating bike"]]
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end

      def delete(request, bike_id)
        if Repositories::Bikes.new.delete(id: bike_id)
          [200, {"content-type" => "text/plain"}, ["Delete with ID #{bike_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error deleting bike"]]
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
