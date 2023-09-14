require_relative "../app/records/account"
require_relative "../app/models/account"
require "active_record"

module Accounts
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def create(email:, password:)
      record = ::App::Records::Account.create(email: email, password: password)
      to_model(record).to_h
    end

    def find(id:)
      record = ::App::Records::Account.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email(email)
      record = ::App::Records::Account.find_by(email: email)
      to_model(record).to_h if record
    end

    def update(id:, params:)
      record = ::App::Records::Account.find(id)
      record.update(params)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end

    def to_model(record)
      ::App::Models::Account.new(
        id: record.id,
        email: record.email
      )
    end
  end
end
