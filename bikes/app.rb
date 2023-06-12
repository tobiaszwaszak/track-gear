require_relative "controller"
module Bikes
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/"
        Controller.new.index(request)
      when "/bikes"
        case request.request_method
        when "GET"
          Controller.new.index(request)
        when "POST"
          Controller.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      when %r{/bikes/(\d+)}
        bike_id = $1.to_i
        case request.request_method
        when "GET"
          Controller.new.read(request, bike_id)
        when "PUT"
          Controller.new.update(request, bike_id)
        when "DELETE"
          Controller.new.delete(request, bike_id)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
