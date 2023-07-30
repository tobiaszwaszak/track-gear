require_relative "../db/records/component"
require_relative "./model"
require "active_record"
require "date"

module Components
  class RecordNotFound < StandardError
  end

  class Repository
    def all
      Db::Records::Component.all.map { |record| to_model(record).to_h }
    end

    def all_by_bikes(bike_id:)
      assignment_table = Db::Records::ComponentAssignment.arel_table

      Db::Records::Component
        .joins(:component_assignments)
        .where(
          Db::Records::ComponentAssignment.arel_table[:bike_id].eq(bike_id)
            .and(assignment_table[:started_at].lteq(Time.now))
            .and(assignment_table[:ended_at].gteq(Time.now).or(assignment_table[:ended_at].eq(nil)))
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

    def to_model(record)
      Components::Model.new(
        id: record.id,
        name: record.name,
        brand: record.brand,
        model: record.model,
        weight: record.weight,
        notes: record.notes,
        bike_id: last_bike_id(record)
      )
    end

    def last_bike_id(record)
      record.component_assignments.where(ended_at: nil).last&.bike&.id
    end
  end
end
