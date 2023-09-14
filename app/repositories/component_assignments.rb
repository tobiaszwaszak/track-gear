require_relative "../records/component_assignment"
require "active_record"
require "date"
module App
module Repositories
  class RecordNotFound < StandardError
  end

  class ComponentAssignments
    def create(bike_id:, component_id:)
      Records::ComponentAssignment.create(bike_id: bike_id, component_id: component_id, started_at: Time.now)
    end

    def delete(bike_id:, component_id:)
      assignment = Records::ComponentAssignment.find_by!(bike_id:, component_id:, ended_at: nil)
      assignment.update(ended_at: Time.now)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end
  end
end
end
