require "active_record"
require_relative "./repository"
require_relative "./contract"

module ComponentAssignments
  class Controller
    def create(request)
      component_data = ComponentAssignments::Contract.new.call(JSON.parse(request.body.read))
      if component_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      else
        component = ComponentAssignments::Repository.new.create(
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

    def delete(request, assignment_id)
      if ComponentAssignments::Repository.new.delete(id: assignment_id)
        [200, {"content-type" => "text/plain"}, ["Delete with ID #{assignment_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error deleting component assignments"]]
      end
    rescue ComponentAssignments::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end
  end
end
