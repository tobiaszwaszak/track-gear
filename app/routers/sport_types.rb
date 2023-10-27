require_relative "../controllers/sport_types"
module App
  module Routers
    class SportTypes
      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when "/"
          Controllers::SportTypes.new.index(request)
        when "/sport_types"
          case request.request_method
          when "GET"
            Controllers::SportTypes.new.index(request)
          when "POST"
            Controllers::SportTypes.new.create(request)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        when %r{/sport_types/(\d+)}
          sport_type_id = $1.to_i
          case request.request_method
          when "GET"
            Controllers::SportTypes.new.read(request, sport_type_id)
          when "PUT"
            Controllers::SportTypes.new.update(request, sport_type_id)
          when "DELETE"
            Controllers::SportTypes.new.delete(request, sport_type_id)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        else
          [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
        end
      end
    end
  end
end
