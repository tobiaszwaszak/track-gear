require "active_record"

module Db
  module Records
    class User < ActiveRecord::Base
      has_secure_password
    end
  end
end
