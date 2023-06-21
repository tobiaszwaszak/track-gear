require 'active_record'
require "dotenv"
require_relative "../db/Component"

Dotenv.load(".env.development") if ENV["RACK_ENV"] == "development"
Dotenv.load(".env.test") if ENV["RACK_ENV"] == "test"
module Components
  class Controller
    def initialize
      setup_database
    end

    def index(request)
      bike_id = request.params["bike_id"]

      if bike_id
        filtered_components = Db::Component.where(bike_id: bike_id)
        [200, { 'content-type' => 'application/json' }, [filtered_components.to_json]]
      else
        components = Db::Component.all
        [200, { 'content-type' => 'application/json' }, [components.to_json]]
      end
    end

    def create(request)
      component_data = JSON.parse(request.body.read)

      component = Db::Component.create(
        bike_id: component_data['bike_id'],
        name: component_data['name'],
        description: component_data['description']
      )

      if component
        [201, { 'content-type' => 'text/plain' }, ['Create']]
      else
        [500, { 'content-type' => 'text/plain' }, ['Error creating component']]
      end
    end

    def read(request, component_id)
      component = Db::Component.find_by(id: component_id)

      if component
        [200, { 'content-type' => 'application/json' }, [component.to_json]]
      else
        [404, { 'content-type' => 'text/plain' }, ['Not Found']]
      end
    end

    def update(request, component_id)
      component_data = JSON.parse(request.body.read)
      component = Db::Component.find_by(id: component_id)

      if component
        if component.update(component_data)
          [200, { 'content-type' => 'text/plain' }, ["Update with ID #{component_id}"]]
        else
          [500, { 'content-type' => 'text/plain' }, ['Error updating component']]
        end
      else
        [404, { 'content-type' => 'text/plain' }, ['Not Found']]
      end
    end

    def delete(request, component_id)
      component = Db::Component.find_by(id: component_id)

      if component
        if component.destroy
          [200, { 'content-type' => 'text/plain' }, ["Delete with ID #{component_id}"]]
        else
          [500, { 'content-type' => 'text/plain' }, ['Error deleting component']]
        end
      else
        [404, { 'content-type' => 'text/plain' }, ['Not Found']]
      end
    end

    private

    def setup_database
      ActiveRecord::Base.establish_connection(
        adapter: "sqlite3",
        database: ENV["BIKES_DB"]
      )
    end
  end
end
