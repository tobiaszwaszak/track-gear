require_relative "../app/controllers/components"
module Components
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/"
        ::App::Controllers::Components.new.index(request)
      when "/components"
        case request.request_method
        when "GET"
          ::App::Controllers::Components.new.index(request)
        when "POST"
          ::App::Controllers::Components.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      when %r{/components/(\d+)}
        component_id = $1.to_i
        case request.request_method
        when "GET"
          ::App::Controllers::Components.new.read(request, component_id)
        when "PUT"
          ::App::Controllers::Components.new.update(request, component_id)
        when "DELETE"
          ::App::Controllers::Components.new.delete(request, component_id)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
