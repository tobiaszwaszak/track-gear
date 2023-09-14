require "active_record"

module App
  module Records
    class Bike < ActiveRecord::Base
      has_many :component_assignments, class_name: "::App::Records::ComponentAssignment"
      has_many :components, through: :component_assignments
    end
  end
end
