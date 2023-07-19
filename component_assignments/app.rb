require_relative "controller"
module ComponentAssignments
  class App
    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
      when "/component_assignments"
        case request.request_method
        when "POST"
          Controller.new.create(request)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      when %r{/component_assignments/(\d+)}
        assignment_id = $1.to_i
        case request.request_method
        when "DELETE"
          Controller.new.delete(request, assignment_id)
        else
          [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
        end
      else
        [405, {"Content-Type" => "text/plain"}, ["Method Not Allowed"]]
      end
    end
  end
end
