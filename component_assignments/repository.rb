require_relative "../db/records/component_assignment"
require "active_record"
require "date"
module ComponentAssignments
  class RecordNotFound < StandardError
  end

  class Repository
    def create(bike_id:, component_id:)
      Db::Records::ComponentAssignment.create(bike_id: bike_id, component_id: component_id, started_at: Time.now)
    end

    def delete(bike_id:, component_id:)
      assignment = Db::Records::ComponentAssignment.find_by!(bike_id:, component_id:, ended_at: nil)
      assignment.update(ended_at: Time.now)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end
  end
end
