require_relative "../app/records/bike"
require_relative "../app/models/bike"
require "active_record"

module Bikes
  class RecordNotFound < StandardError
  end

  class Repository
    def all
      ::App::Records::Bike.all.map { |record| to_model(record).to_h }
    end

    def create(name:, brand:, model:, weight:, notes:)
      record = ::App::Records::Bike.create(name: name, brand: brand, model: model, weight: weight, notes: notes)
      to_model(record).to_h
    end

    def find(id:)
      record = ::App::Records::Bike.find(id)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def update(id:, params:)
      record = ::App::Records::Bike.find(id)
      record.update(params)
      to_model(record).to_h
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    def delete(id:)
      record = ::App::Records::Bike.find(id)
      record.destroy!
    rescue ActiveRecord::RecordNotFound
      raise RecordNotFound.new
    end

    private

    def to_model(record)
      ::App::Models::Bike.new(
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
