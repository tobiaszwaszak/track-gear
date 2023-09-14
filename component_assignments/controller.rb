require "active_record"
require_relative "../app/repositories/component_assignments"
require_relative "./contract"
module ComponentAssignments
  class Controller
    def create(request)
      component_data = ::ComponentAssignments::Contract.new.call(JSON.parse(request.body.read))
      if component_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      else
        component = ::App::Repositories::ComponentAssignments.new.create(
          bike_id: component_data["bike_id"],
          component_id: component_data["component_id"]
        )
        if component
          [201, {"content-type" => "text/plain"}, ["Create"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error creating component assignments"]]
        end
      end
    end

    def delete(request)
      component_data = ::ComponentAssignments::Contract.new.call(JSON.parse(request.body.read))
      if component_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      else
        delete = ::App::Repositories::ComponentAssignments.new.delete(
          bike_id: component_data["bike_id"],
          component_id: component_data["component_id"]
        )
        if delete
          [200, {"content-type" => "text/plain"}, ["Delete assignment"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error deleting component assignments"]]
        end
      end
    rescue ::App::Repositories::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end
  end
end
