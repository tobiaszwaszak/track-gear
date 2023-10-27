require_relative "../controllers/bike_sport_types"
module App
  module Routers
    class BikeSportTypes
      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when "/bike_sport_types"
          case request.request_method
          when "POST"
            Controllers::BikeSportTypes.new.create(request)
          when "DELETE"
            Controllers::BikeSportTypes.new.delete(request)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      end
    end
  end
end
