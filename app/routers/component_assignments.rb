require_relative "../controllers/component_assignments"
module App
  module Routers
    class ComponentAssignments
      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when "/component_assignments"
          case request.request_method
          when "POST"
            Controllers::ComponentAssignments.new.create(request)
          when "DELETE"
            Controllers::ComponentAssignments.new.delete(request)
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
