require "active_record"

module App
  module Records
    class SportType < ActiveRecord::Base
      has_many :bike_sport_types
      has_many :bikes, through: :bike_sport_types
      has_many :activities
    end
  end
end
