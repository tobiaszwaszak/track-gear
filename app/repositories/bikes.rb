require_relative "../records/bike"
require_relative "../models/bike"
require "active_record"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class Bikes
      def all
        Records::Bike.all.map { |record| to_model(record).to_h }
      end

      def create(name:, brand:, model:, weight:, notes:)
        record = Records::Bike.create(name: name, brand: brand, model: model, weight: weight, notes: notes)
        to_model(record).to_h
      end

      def find(id:)
        record = Records::Bike.find(id)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def update(id:, params:)
        record = Records::Bike.find(id)
        record.update(params)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def delete(id:)
        record = Records::Bike.find(id)
        record.destroy!
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      private

      def to_model(record)
        Models::Bike.new(
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
end
