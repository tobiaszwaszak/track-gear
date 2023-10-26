require "json"
require_relative "../repositories/sport_types"
require_relative "../contracts/sport_type"

module App
  module Controllers
    class SportTypes
      def index(request)
        sport_types = Repositories::SportTypes.new.all
        [200, {"content-type" => "application/json"}, [sport_types.to_json]]
      end

      def create(request)
        sport_type_data = Contracts::SportType.new.call(JSON.parse(request.body.read))
        if sport_type_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating sport type"]]
        else
          sport_type = Repositories::SportTypes.new.create(name: sport_type_data["name"])
          if sport_type
            [201, {"content-type" => "text/plain"}, ["Create"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error creating sport type"]]
          end
        end
      end

      def read(request, sport_type_id)
        sport_type = Repositories::SportTypes.new.find(id: sport_type_id)
        [200, {"content-type" => "application/json"}, [sport_type.to_json]]
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end

      def update(request, sport_type_id)
        sport_type_data = Contracts::SportType.new.call(JSON.parse(request.body.read))
        if sport_type_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating sport type"]]
        elsif Repositories::SportTypes.new.update(id: sport_type_id, params: sport_type_data.to_h)
          [200, {"content-type" => "text/plain"}, ["Update with ID #{sport_type_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error updating sport type"]]
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end

      def delete(request, sport_type_id)
        if Repositories::SportTypes.new.delete(id: sport_type_id)
          [200, {"content-type" => "text/plain"}, ["Delete with ID #{sport_type_id}"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error deleting sport type"]]
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
