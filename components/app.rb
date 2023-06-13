require_relative "controller"
module Components
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/"
        Controller.new.index(request)
      when "/components"
        case request.request_method
        when "GET"
          Controller.new.index(request)
        when "POST"
          Controller.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      when %r{/components/(\d+)}
        component_id = $1.to_i
        case request.request_method
        when "GET"
          Controller.new.read(request, component_id)
        when "PUT"
          Controller.new.update(request, component_id)
        when "DELETE"
          Controller.new.delete(request, component_id)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [404, {"Content-Type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
