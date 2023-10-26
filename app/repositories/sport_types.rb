require_relative "../records/sport_type"
require_relative "../models/sport_type"
require "active_record"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class SportTypes
      def all
        Records::SportType.all.map { |record| to_model(record).to_h }
      end

      def create(name:)
        record = Records::SportType.create(name: name)
        to_model(record).to_h
      end

      def find(id:)
        record = Records::SportType.find(id)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def update(id:, params:)
        record = Records::SportType.find(id)
        record.update(params)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def delete(id:)
        record = Records::SportType.find(id)
        record.destroy!
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      private

      def to_model(record)
        Models::SportType.new(
          id: record.id,
          name: record.name
        )
      end
    end
  end
end
