require_relative "../db/records/component"
require_relative "./model"
require "active_record"
require "date"

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

    def all_by_bikes(bike_id:)
      assignment_table = Db::Records::ComponentAssignment.arel_table

      Db::Records::Component
        .joins(:component_assignments)
        .where(
          Db::Records::ComponentAssignment.arel_table[:bike_id].eq(bike_id)
            .and(assignment_table[:start_date].lteq(Date.today))
            .and(assignment_table[:end_date].gteq(Date.today).or(assignment_table[:end_date].eq(nil)))
        )
        .map { |record| to_model(record).to_h }
    end

    def create(name:, brand:, model:, weight:, notes:)
      record = Db::Records::Component.create(
        name: name,
        brand: brand,
        model: model,
        weight: weight,
        notes: notes
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
      Components::Model.new(
        id: record.id,
        name: record.name,
        brand: record.brand,
        model: record.model,
        weight: record.weight,
        notes: record.notes,
        bike_id: record&.bikes&.last&.id
      )
    end
  end
end
