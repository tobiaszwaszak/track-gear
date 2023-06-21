require "active_record"

module Db
  class Component < ActiveRecord::Base
    belongs_to :bike, optional: true
  end
end
