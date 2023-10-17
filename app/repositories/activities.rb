require_relative "../records/activity"
require_relative "../models/activity"
require "active_record"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class Activities
      def all
        Records::Activity.all.map { |record| to_model(record).to_h }
      end

      def create(distance:, time:, external_id:, activity_date:, name:, commute:, sport_type:)
        record = Records::Activity.create(
          distance: distance,
          time: time,
          external_id: external_id,
          activity_date: activity_date,
          name: name,
          commute: commute,
          sport_type: sport_type
        )
        to_model(record).to_h
      end

      def find(id:)
        record = Records::Activity.find(id)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def find_by_external_id(external_id)
        record = Records::Activity.find_by(external_id: external_id)
        to_model(record).to_h if record
      end

      def update(id:, params:)
        record = Records::Activity.find(id)
        record.update(params)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def delete(id:)
        record = Records::Activity.find(id)
        record.destroy!
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      private

      def to_model(record)
        Models::Activity.new(
          id: record.id,
          distance: record.distance,
          time: record.time,
          external_id: record.external_id,
          activity_date: record.activity_date,
          name: record.name,
          commute: record.commute,
          sport_type: record.sport_type
        )
      end
    end
  end
end
