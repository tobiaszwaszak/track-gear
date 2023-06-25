require_relative "../db/records/bike"
require "active_record"

module Bikes
  class Repository
    def initialize
      setup_database
    end

    def all
      Db::Records::Bike.all
    end

    def create(name:)
      Db::Records::Bike.create(name: name)
    end

    def find(id:)
      Db::Records::Bike.find(id)
    end

    def update(id:, params:)
      record = find(id: id)
      record.update(params)
      record
    end

    def delete(id:)
      record = find(id: id)
      record.destroy!
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end
  end
end
