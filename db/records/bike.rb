require "active_record"

module Db
  module Records
    class Bike < ActiveRecord::Base
      has_many :component_assignments
      has_many :components, through: :component_assignments
    end
  end
end
