require_relative "../records/component_assignment"
require "active_record"
require "date"
module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class ComponentAssignments
      def create(bike_id:, component_id:, started_at:, ended_at:)
        started_at = Time.now if started_at.blank?

        Records::ComponentAssignment.create(
          bike_id: bike_id,
          component_id: component_id,
          started_at: started_at,
          ended_at: ended_at
        )
      end

      def delete(bike_id:, component_id:, ended_at:)
        ended_at = Time.now if ended_at.blank?
        assignment = Records::ComponentAssignment.find_by!(bike_id: bike_id, component_id: component_id, ended_at: nil)
        assignment.update(ended_at: ended_at)
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end
    end
  end
end
