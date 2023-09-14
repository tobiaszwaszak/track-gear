require "json"
require "byebug"
require_relative "../app/repositories/bikes"
require_relative "./contract"

module Bikes
  class Controller
    def index(request)
      bikes = ::App::Repositories::Bikes.new.all
      [200, {"content-type" => "application/json"}, [bikes.to_json]]
    end

    def create(request)
      bike_data = Bikes::Contract.new.call(JSON.parse(request.body.read))
      if bike_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
      else
        bike = ::App::Repositories::Bikes.new.create(
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
      bike = ::App::Repositories::Bikes.new.find(id: bike_id)
      [200, {"content-type" => "application/json"}, [bike.to_json]]
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def update(request, bike_id)
      bike_data = Bikes::Contract.new.call(JSON.parse(request.body.read))
      if bike_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating bike"]]
      elsif ::App::Repositories::Bikes.new.update(id: bike_id, params: bike_data.to_h)
        [200, {"content-type" => "text/plain"}, ["Update with ID #{bike_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error updating bike"]]
      end
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def delete(request, bike_id)
      if ::App::Repositories::Bikes.new.delete(id: bike_id)
        [200, {"content-type" => "text/plain"}, ["Delete with ID #{bike_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error deleting bike"]]
      end
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end
  end
end
