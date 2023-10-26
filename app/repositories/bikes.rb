require_relative "../records/bike"
require_relative "../records/activity"
require_relative "../records/bike_sport_type"
require_relative "../records/sport_type"
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

      def create(name:, brand:, model:, weight:, notes:, commute:)
        record = Records::Bike.create(
          name: name,
          brand: brand,
          model: model,
          weight: weight,
          notes: notes,
          commute: commute
        )
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
          notes: record.notes,
          commute: record.commute,
          distance: calculate_distance(record),
          time: calculate_time(record)
        )
      end

      def calculate_distance(record)
        (Records::Activity.where(commute: record.commute, sport_type: record.sport_types).sum(:distance) / 1000).round(2).to_s + " KM"
      end

      def calculate_time(record)
        seconds = Records::Activity.where(commute: record.commute, sport_type: record.sport_types).sum(:time)
        humanize(seconds)
      end

      def humanize(secs)
        [[60, :seconds], [60, :minutes], [Float::INFINITY, :hours]].map { |count, name|
          if secs > 0
            secs, n = secs.divmod(count)

            "#{n.to_i} #{name}" unless n.to_i == 0
          end
        }.compact.reverse.join(" ")
      end
    end
  end
end
