require_relative "../app/records/account"
require "active_record"

module Auth
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def find(id:)
      ::App::Records::Account.find(id)
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email!(email)
      ::App::Records::Account.find_by!(email: email)
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
