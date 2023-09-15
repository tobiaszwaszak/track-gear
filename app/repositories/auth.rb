require_relative "../records/account"
require "active_record"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class Auth
      def initialize
        setup_database
      end

      def find(id:)
        Records::Account.find(id)
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def find_by_email!(email)
        Records::Account.find_by!(email: email)
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
end
