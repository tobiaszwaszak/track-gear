module App
  module Models
    class Activity < Data.define(:id, :distance, :time, :external_id, :activity_date, :name, :commute, :sport_type)
    end
  end
end
