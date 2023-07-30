require_relative "../db/records/account"
require "active_record"

module Auth
  class RecordNotFound < StandardError
  end

  class Repository
    def find(id:)
      Db::Records::Account.find(id)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email!(email)
      Db::Records::Account.find_by!(email: email)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end
  end
end
