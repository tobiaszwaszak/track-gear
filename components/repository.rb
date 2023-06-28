require_relative "../db/records/component"
require_relative "./model"
require "active_record"

module Components
  class RecordNotFound < StandardError
  end

  class Repository
    def initialize
      setup_database
    end

    def all
      Db::Records::Component.all.map { |record| to_model(record).to_h }
    end

    def all_by(filters)
      Db::Records::Component.where(filters).map { |record| to_model(record).to_h }
    end

    def create(bike_id:, name:, description:)
      record = Db::Records::Component.create(
        bike_id: bike_id,
        name: name,
        description: description
      )
      to_model(record).to_h
    end

    def find(id:)
      record = Db::Records::Component.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def update(id:, params:)
      record = Db::Records::Component.find(id)
      record.update(params)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def delete(id:)
      record = Db::Records::Component.find(id)
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
      Components::Model.new(id: record.id, name: record.name, description: record.description, bike_id: record.bike_id)
    end
  end
end
