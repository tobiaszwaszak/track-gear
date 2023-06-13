require "csv"

module Components
  class Controller
    def initialize
      @database = "components.csv"
    end

    def index(request)
      bike_id = request.params["bike_id"]
      components = read_database

      if bike_id
        filtered_components = components.select { |component| component["bike_id"].to_i == bike_id.to_i }
        [200, {"content-type" => "application/json"}, [filtered_components.to_json]]
      else
        [200, {"content-type" => "application/json"}, [components.to_json]]
      end
    end

    def create(request)
      component_data = JSON.parse(request.body.read)
      components = read_database
      component_id = read_database.empty? ? 1 : read_database.map { |component| component["id"].to_i }.max + 1
      new_component = {
        id: component_id,
        bike_id: component_data["bike_id"],
        name: component_data["name"],
        description: component_data["description"]
      }
      components << new_component
      write_database(components)
      [201, {"content-type" => "text/plain"}, ["Create"]]
    end

    def read(request, component_id)
      components = read_database
      component = components.find { |b| b["id"].to_i == component_id }
      if component
        [200, {"content-type" => "application/json"}, [component.to_json]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def update(request, component_id)
      component_data = JSON.parse(request.body.read)
      components = read_database
      index = components.find_index { |c| c["id"].to_i == component_id }
      if index
        components[index] = component_data
        write_database(components)
        [200, {"content-type" => "text/plain"}, ["Update with ID #{component_id}"]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    def delete(request, component_id)
      components = read_database
      index = components.find_index { |b| b["id"].to_i == component_id }
      if index
        components.delete_at(index)
        write_database(components)
        [200, {"content-type" => "text/plain"}, ["Delete with ID #{component_id}"]]
      else
        [404, {"content-type" => "text/plain"}, ["Not Found"]]
      end
    end

    private

    def read_database
      CSV.read(@database, headers: true, header_converters: :symbol).map(&:to_h).map { |array| array.map { |key, v| [key.to_s, v] }.to_h }
    end

    def write_database(data)
      CSV.open(@database, "w", write_headers: true, headers: data.first&.keys) do |csv|
        data.each { |row| csv << row.values }
      end
    end
  end
end
