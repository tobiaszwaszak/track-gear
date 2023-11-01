require "active_record"
require_relative "../repositories/bike_sport_types"
require_relative "../contracts/bike_sport_type"

module App
  module Controllers
    class BikeSportTypes
      def create(request)
        bike_sport_type_data = Contracts::BikeSportType.new.call(JSON.parse(request.body.read))
        if bike_sport_type_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating bike sport type"]]
        else
          bike_sport_type = Repositories::BikeSportTypes.new.create(
            bike_id: bike_sport_type_data["bike_id"],
            sport_type_id: bike_sport_type_data["sport_type_id"]
          )
          if bike_sport_type
            [201, {"content-type" => "text/plain"}, ["Create"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error creating bike sport type"]]
          end
        end
      end

      def delete(request)
        bike_sport_type_data = Contracts::BikeSportType.new.call(JSON.parse(request.body.read))
        if bike_sport_type_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error deleting bike sport type"]]
        else
          delete = Repositories::BikeSportTypes.new.delete(
            bike_id: bike_sport_type_data["bike_id"],
            sport_type_id: bike_sport_type_data["sport_type_id"]
          )
          if delete
            [200, {"content-type" => "text/plain"}, ["Delete assignment"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error deleting bike sport type"]]
          end
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
