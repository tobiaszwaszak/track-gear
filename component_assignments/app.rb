require_relative "../app/controllers/component_assignments"
module ComponentAssignments
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/component_assignments"
        case request.request_method
        when "POST"
          ::App::Controllers::ComponentAssignments.new.create(request)
        when "DELETE"
          ::App::Controllers::ComponentAssignments.new.delete(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
      end
    end
  end
end
