require "active_record"
require "bcrypt"
module Db
  module Records
    class Account < ActiveRecord::Base
      has_secure_password
    end
  end
end
