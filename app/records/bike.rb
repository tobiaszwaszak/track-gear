require "active_record"

module App
  module Records
    class Bike < ActiveRecord::Base
      has_many :component_assignments
      has_many :components, through: :component_assignments
      has_many :bike_sport_types
      has_many :sport_types, through: :bike_sport_types
    end
  end
end
