require_relative "../db/records/account"
require "active_record"

module Auth
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def find(id:)
      record = Db::Records::Account.find(id)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email!(email)
      Db::Records::Account.find_by!(email: email)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end
  end
end
