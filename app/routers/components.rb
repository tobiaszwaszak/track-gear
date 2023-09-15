require_relative "../controllers/components"
module App
module Routers
  class Components
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/"
        Controllers::Components.new.index(request)
      when "/components"
        case request.request_method
        when "GET"
          Controllers::Components.new.index(request)
        when "POST"
          Controllers::Components.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      when %r{/components/(\d+)}
        component_id = $1.to_i
        case request.request_method
        when "GET"
          Controllers::Components.new.read(request, component_id)
        when "PUT"
          Controllers::Components.new.update(request, component_id)
        when "DELETE"
          Controllers::Components.new.delete(request, component_id)
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
