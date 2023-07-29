require_relative "../db/records/account"
require_relative "./model"
require "active_record"

module Accounts
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def create(email:, password:)
      record = Db::Records::Account.create(email: email, password: password)
      to_model(record).to_h
    end

    def find(id:)
      record = Db::Records::Account.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email(email)
      record = Db::Records::Account.find_by(email: email)
      to_model(record).to_h if record
    end

    def update(id:, params:)
      record = Db::Records::Account.find(id)
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
      Accounts::Model.new(
        id: record.id,
        email: record.email
      )
    end
  end
end
