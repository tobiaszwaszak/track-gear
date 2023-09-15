require_relative "../controllers/bikes"
module App
  module Routers
    class Bikes
      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when "/"
          Controllers::Bikes.new.index(request)
        when "/bikes"
          case request.request_method
          when "GET"
            Controllers::Bikes.new.index(request)
          when "POST"
            Controllers::Bikes.new.create(request)
          else
            [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
          end
        when %r{/bikes/(\d+)}
          bike_id = $1.to_i
          case request.request_method
          when "GET"
            Controllers::Bikes.new.read(request, bike_id)
          when "PUT"
            Controllers::Bikes.new.update(request, bike_id)
          when "DELETE"
            Controllers::Bikes.new.delete(request, bike_id)
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
