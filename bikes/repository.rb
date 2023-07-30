require_relative "../db/records/bike"
require_relative "./model"
require "active_record"

module Bikes
  class RecordNotFound < StandardError
  end

  class Repository
    def all
      Db::Records::Bike.all.map { |record| to_model(record).to_h }
    end

    def create(name:, brand:, model:, weight:, notes:)
      record = Db::Records::Bike.create(name: name, brand: brand, model: model, weight: weight, notes: notes)
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

    def to_model(record)
      Bikes::Model.new(
        id: record.id,
        name: record.name,
        brand: record.brand,
        model: record.model,
        weight: record.weight,
        notes: record.notes
      )
    end
  end
end
