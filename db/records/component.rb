require "active_record"

module Db
  module Records
    class Component < ActiveRecord::Base
      belongs_to :bike, optional: true
    end
  end
end
