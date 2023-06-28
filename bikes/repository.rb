require_relative "../db/records/bike"
require_relative "./model"
require "active_record"

module Bikes
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def all
      Db::Records::Bike.all.map { |record| to_model(record).to_h }
    end

    def create(name:)
      record = Db::Records::Bike.create(name: name)
      to_model(record).to_h
    end

    def find(id:)
      record = Db::Records::Bike.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def update(id:, params:)
      record = Db::Records::Bike.find(id)
      record.update(params)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def delete(id:)
      record = Db::Records::Bike.find(id)
      record.destroy!
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    private

    def setup_database
      ActiveRecord::Base.configurations = YAML.load_file("db/configuration.yml")
      ActiveRecord::Base.establish_connection(ENV["RACK_ENV"].to_sym)
    end

    def to_model(record)
      Bikes::Model.new(id: record.id, name: record.name)
    end
  end
end
