require "active_record"
require_relative "./repository"

module Components
  class Controller
    def index(request)
      bike_id = request.params["bike_id"]

      if bike_id
        filtered_components = Components::Repository.new.all_by(bike_id: bike_id)
        [200, {"content-type" => "application/json"}, [filtered_components.to_json]]
      else
        components = Components::Repository.new.all
        [200, {"content-type" => "application/json"}, [components.to_json]]
      end
    end

    def create(request)
      component_data = JSON.parse(request.body.read)

      component = Components::Repository.new.create(
        bike_id: component_data["bike_id"],
        name: component_data["name"],
        description: component_data["description"]
      )
      if component
        [201, {"content-type" => "text/plain"}, ["Create"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      end
    end

    def read(request, component_id)
      component = Components::Repository.new.find(id: component_id)
      [200, {"content-type" => "application/json"}, [component.to_json]]
    rescue Components::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def update(request, component_id)
      component_data = JSON.parse(request.body.read)

      if Components::Repository.new.update(id: component_id, params: component_data)
        [200, {"content-type" => "text/plain"}, ["Update with ID #{component_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error updating component"]]
      end
    rescue Components::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def delete(request, component_id)
      if Components::Repository.new.delete(id: component_id)
        [200, {"content-type" => "text/plain"}, ["Delete with ID #{component_id}"]]
      else
        [500, {"content-type" => "text/plain"}, ["Error deleting component"]]
      end
    rescue Components::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end
  end
end
