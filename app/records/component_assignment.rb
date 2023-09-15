require "active_record"

module App
  module Records
    class ComponentAssignment < ActiveRecord::Base
      belongs_to :bike
      belongs_to :component
    end
  end
end
