require_relative "../records/component"
require_relative "../models/component"
require "active_record"
require "date"

module App
  module Repositories
    class RecordNotFound < StandardError
    end

    class Components
      def all
        Records::Component.all.map { |record| to_model(record).to_h }
      end

      def all_by_bikes(bike_id:)
        assignment_table = Records::ComponentAssignment.arel_table

        Records::Component
          .joins(:component_assignments)
          .where(
            Records::ComponentAssignment.arel_table[:bike_id].eq(bike_id)
              .and(assignment_table[:started_at].lteq(Time.now))
              .and(assignment_table[:ended_at].gteq(Time.now).or(assignment_table[:ended_at].eq(nil)))
          )
          .map { |record| to_model(record).to_h }
      end

      def create(name:, brand:, model:, weight:, notes:)
        record = Records::Component.create(
          name: name,
          brand: brand,
          model: model,
          weight: weight,
          notes: notes
        )
        to_model(record).to_h
      end

      def find(id:)
        record = Records::Component.find(id)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def update(id:, params:)
        record = Records::Component.find(id)
        record.update(params)
        to_model(record).to_h
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      def delete(id:)
        record = Records::Component.find(id)
        record.destroy!
      rescue ActiveRecord::RecordNotFound
        raise RecordNotFound.new
      end

      private

      def to_model(record)
        Models::Component.new(
          id: record.id,
          name: record.name,
          brand: record.brand,
          model: record.model,
          weight: record.weight,
          notes: record.notes,
          bike_id: last_bike_id(record),
          distance: calculate_distance(record),
          time: calculate_time(record)
        )
      end

      def last_bike_id(record)
        record.component_assignments.where(ended_at: nil).last&.bike&.id
      end

      def calculate_distance(record)
        total_distance = 0
        record.component_assignments.each do |ca|
          activity_query = Records::Activity.where(commute: ca.bike.commute, sport_type: ca.bike.sport_type)
          activity_query = activity_query.where("activity_date >= ?", ca.started_at)
          activity_query = activity_query.where("activity_date <= ?", ca.ended_at) if ca.ended_at
          total_distance += activity_query.sum(:distance)
        end
        (total_distance / 1000).round(2).to_s + " KM"
      end

      def calculate_time(record)
        total_time = 0
        record.component_assignments.each do |ca|
          activity_query = Records::Activity.where(commute: ca.bike.commute, sport_type: ca.bike.sport_type)
          activity_query = activity_query.where("activity_date >= ?", ca.started_at)
          activity_query = activity_query.where("activity_date <= ?", ca.ended_at) if ca.ended_at
          total_time += activity_query.sum(:time)
        end
        humanize(total_time)
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
