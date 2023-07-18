require "active_record"

module Db
  module Records
    class Component < ActiveRecord::Base
      has_many :component_assignments
      has_many :bikes, through: :component_assignments
    end
  end
end
