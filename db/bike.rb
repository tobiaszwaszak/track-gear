require "active_record"

module Db
  class Bike < ActiveRecord::Base
    has_many :components
  end
end
