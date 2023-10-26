require "active_record"

module App
  module Records
    class BikeSportType < ActiveRecord::Base
      belongs_to :sport_type
      belongs_to :bike
    end
  end
end
