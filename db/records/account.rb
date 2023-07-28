require "active_record"

module Db
  module Records
    class Account < ActiveRecord::Base
      has_secure_password
    end
  end
end
