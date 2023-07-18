require "active_record"
require_relative "./repository"
require_relative "./contract"

module Components
  class Controller
    def index(request)
      bike_id = request.params["bike_id"]

      if bike_id
        filtered_components = Components::Repository.new.all_by_bikes(bike_id: bike_id)
        [200, {"content-type" => "application/json"}, [filtered_components.to_json]]
      else
        components = Components::Repository.new.all
        [200, {"content-type" => "application/json"}, [components.to_json]]
      end
    end

    def create(request)
      component_data = Components::Contract.new.call(JSON.parse(request.body.read))
      if component_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      else
        component = Components::Repository.new.create(
          name: component_data["name"],
          brand: component_data["brand"],
          model: component_data["model"],
          weight: component_data["weight"],
          notes: component_data["notes"]
        )
        if component
          [201, {"content-type" => "text/plain"}, ["Create"]]
        else
          [500, {"content-type" => "text/plain"}, ["Error creating component"]]
        end
      end
    end

    def read(request, component_id)
      component = Components::Repository.new.find(id: component_id)
      [200, {"content-type" => "application/json"}, [component.to_json]]
    rescue Components::RecordNotFound
      [404, {"content-type" => "text/plain"}, ["Not Found"]]
    end

    def update(request, component_id)
      component_data = Components::Contract.new.call(JSON.parse(request.body.read))
      if component_data.errors.to_h.any?
        [500, {"content-type" => "text/plain"}, ["Error creating component"]]
      elsif Components::Repository.new.update(id: component_id, params: component_data.to_h)
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
