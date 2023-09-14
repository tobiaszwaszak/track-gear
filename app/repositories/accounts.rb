require_relative "../records/account"
require_relative "../models/account"
require "active_record"


module App
module Repositories
  class RecordNotFound < StandardError
  end

  class Accounts
    def initialize
      setup_database
    end

    def create(email:, password:)
      record = Records::Account.create(email: email, password: password)
      to_model(record).to_h
    end

    def find(id:)
      record = Records::Account.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def find_by_email(email)
      record = Records::Account.find_by(email: email)
      to_model(record).to_h if record
    end

    def update(id:, params:)
      record = Records::Account.find(id)
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
      Models::Account.new(
        id: record.id,
        email: record.email
      )
    end
  end
end
end
