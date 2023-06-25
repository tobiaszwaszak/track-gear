require "active_record"

module Db
  module Records
    class Bike < ActiveRecord::Base
      has_many :components
    end
  end
end
