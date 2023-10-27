require "active_record"

module App
  module Records
    class Activity < ActiveRecord::Base
      belongs_to :sport_type
    end
  end
end
