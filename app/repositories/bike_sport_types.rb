require_relative "../records/bike_sport_type"
require "active_record"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class BikeSportTypes
      def create(bike_id:, sport_type_id:)
        Records::BikeSportType.create(
          bike_id: bike_id,
          sport_type_id: sport_type_id
        )
      end

      def delete(bike_id:, sport_type_id:)
        bst = Records::BikeSportType.find_by!(bike_id: bike_id, sport_type_id: sport_type_id)
        bst.destroy!
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end
    end
  end
end
