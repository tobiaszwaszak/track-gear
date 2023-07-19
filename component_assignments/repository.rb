require_relative "../db/records/component_assignment"
require "active_record"
require "date"

module ComponentAssignments
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def create(bike_id:, component_id:)
      Db::Records::ComponentAssignment.create(bike_id: bike_id, component_id: component_id, start_date: Date.today)
    end

    def delete(id:)
      assignment = Db::Records::ComponentAssignment.find(id)
      assignment.update(end_date: Date.today)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end
  end
end
