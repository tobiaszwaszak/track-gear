require "active_record"
require_relative "../repositories/component_assignments"
require_relative "../contracts/component_assignment"
module App
  module Controllers
    class ComponentAssignments
      def create(request)
        component_data = Contracts::ComponentAssignment.new.call(JSON.parse(request.body.read))
        if component_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating component"]]
        else
          component = Repositories::ComponentAssignments.new.create(
            bike_id: component_data["bike_id"],
            component_id: component_data["component_id"],
            started_at: component_data["started_at"],
            ended_at: component_data["ended_at"]
          )
          if component
            [201, {"content-type" => "text/plain"}, ["Create"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error creating component assignments"]]
          end
        end
      end

      def delete(request)
        component_data = Contracts::ComponentAssignment.new.call(JSON.parse(request.body.read))
        if component_data.errors.to_h.any?
          [500, {"content-type" => "text/plain"}, ["Error creating component"]]
        else
          delete = Repositories::ComponentAssignments.new.delete(
            bike_id: component_data["bike_id"],
            component_id: component_data["component_id"]
          )
          if delete
            [200, {"content-type" => "text/plain"}, ["Delete assignment"]]
          else
            [500, {"content-type" => "text/plain"}, ["Error deleting component assignments"]]
          end
        end
      rescue Repositories::RecordNotFound
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end
  end
end
